import 'package:assignment/model/product_model.dart';
import 'package:assignment/services/all_api.dart';
import 'package:flutter/material.dart';

class ModifierGroupScreen extends StatefulWidget {
  @override
  _ModifierGroupScreenState createState() => _ModifierGroupScreenState();
}

class _ModifierGroupScreenState extends State<ModifierGroupScreen> {
  final ApiService _apiService = ApiService();
  List<Results> _modifiers = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Fetch data from API
  Future<void> fetchModifiers() async {
    try {
      setState(() => _isLoading = true);
      final response = await _apiService.getModifierGroups(
          vendorId: 1, page: 1, pageSize: 20);
      final productData = product.fromJson(response.data);
      setState(() {
        _modifiers = productData.results ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch modifiers: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Create or Edit Modifier
  Future<void> submitModifier({Results? existingModifier}) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final modifierData = {
      'name': _nameController.text,
      'modifier_group_description': _descriptionController.text,
      'PLU': _skuController.text,
      'min': int.tryParse(_minQuantityController.text) ?? 0,
      'max': int.tryParse(_maxQuantityController.text) ?? 0,
      'vendorId': 1,
    };

    try {
      setState(() => _isLoading = true);

      if (existingModifier == null) {
        await _apiService.createModifierGroup(modifierData);
      } else {
        await _apiService.updateModifierGroup(
          id: existingModifier.id!,
          vendorId: 1,
          data: modifierData,
        );
      }

      await fetchModifiers();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save modifier: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Delete Modifier
  Future<void> deleteModifier(int id) async {
    try {
      setState(() => _isLoading = true);
      await _apiService.deleteModifierGroup(id: id, vendorId: 1);
      await fetchModifiers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete modifier: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _minQuantityController = TextEditingController();
  final TextEditingController _maxQuantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchModifiers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Modifier Groups')),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _modifiers.length,
                    itemBuilder: (context, index) {
                      final modifier = _modifiers[index];
                      return ListTile(
                        title: Text(modifier.name ?? ''),
                        subtitle: Text(modifier.modifierGroupDescription ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _nameController.text = modifier.name ?? '';
                                _descriptionController.text =
                                    modifier.modifierGroupDescription ?? '';
                                _skuController.text = modifier.pLU ?? '';
                                _minQuantityController.text =
                                    modifier.min?.toString() ?? '';
                                _maxQuantityController.text =
                                    modifier.max?.toString() ?? '';
                                _showForm(existingModifier: modifier);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteModifier(modifier.id!),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    onPressed: _showForm,
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
    );
  }

  void _showForm({Results? existingModifier}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              existingModifier == null ? 'Create Modifier' : 'Edit Modifier'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a name' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  TextFormField(
                    controller: _skuController,
                    decoration: InputDecoration(labelText: 'SKU'),
                    validator: (value) => value!.isEmpty ? 'Enter a SKU' : null,
                  ),
                  TextFormField(
                    controller: _minQuantityController,
                    decoration: InputDecoration(labelText: 'Min Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _maxQuantityController,
                    decoration: InputDecoration(labelText: 'Max Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () =>
                  submitModifier(existingModifier: existingModifier),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
