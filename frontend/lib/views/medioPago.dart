import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MedioPagoScreen extends StatelessWidget {
  const MedioPagoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color encabezado = AppColors.encabezado;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Medio de Pago'),
        backgroundColor: encabezado,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Selecciona tu método de pago preferido:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFFE3F2FD),
            child: ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.blue),
              title: const Text(
                'Tarjeta de Crédito o Débito',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Visa, Mastercard, American Express'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context, 'Tarjeta de Crédito o Débito');
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.indigo),
              title: const Text(
                'PayPal',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Paga de forma rápida y segura'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context, 'PayPal');
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance, color: Colors.green),
              title: const Text(
                'Transferencia Bancaria',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('PSE, Bancolombia, Nequi, Daviplata'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context, 'Transferencia Bancaria');
              },
            ),
          ),
        ],
      ),
    );
  }
}
