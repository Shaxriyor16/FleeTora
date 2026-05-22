import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/fleet_theme_colors.dart';
import 'app_button.dart';
import 'fleet_text.dart';

/// Simulates driver self-registration with full passport KYC payload.
void showDriverRegistrationDialog(BuildContext context, AppProvider provider) {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passportCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final nationalityCtrl = TextEditingController(text: 'UZ');
  final issuedCtrl = TextEditingController();
  final expiryCtrl = TextEditingController();
  final licenseCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) {
      final c = ctx.fleetColors;
      return AlertDialog(
        backgroundColor: c.card,
        title: FleetText('Haydovchi ro\'yxatdan o\'tish / KYC', style: TextStyle(fontWeight: FontWeight.w700, color: c.textPrimary)),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FleetText(
                  'Barcha pasport ma\'lumotlari admin panelga keladi. Tasdiqlangach xaritada LIVE ko\'rinadi.',
                  style: TextStyle(fontSize: 12, color: c.textMuted),
                ),
                const SizedBox(height: 16),
                _field(nameCtrl, 'To\'liq ism', c),
                _field(emailCtrl, 'Email', c),
                _field(phoneCtrl, 'Telefon', c),
                const Divider(height: 24),
                FleetText('PASPORT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.brandPrimary, letterSpacing: 1)),
                const SizedBox(height: 10),
                _field(passportCtrl, 'Pasport raqami (AA1234567)', c),
                _field(dobCtrl, 'Tug\'ilgan sana (DD.MM.YYYY)', c),
                _field(nationalityCtrl, 'Fuqarolik (UZ, US...)', c),
                Row(
                  children: [
                    Expanded(child: _field(issuedCtrl, 'Berilgan sana', c)),
                    const SizedBox(width: 8),
                    Expanded(child: _field(expiryCtrl, 'Amal qilish', c)),
                  ],
                ),
                _field(licenseCtrl, 'Haydovchilik guvohnomasi', c),
              ],
            ),
          ),
        ),
        actions: [
          AppButton(label: 'Bekor', variant: AppButtonVariant.secondary, compact: true, width: 90, onPressed: () => Navigator.pop(ctx)),
          AppButton(
            label: 'Yuborish',
            compact: true,
            width: 120,
            onPressed: () {
              if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty || passportCtrl.text.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Ism, email va pasport raqami majburiy')));
                return;
              }
              context.read<AppProvider>().registerDriverWithDocuments(
                    name: nameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    passportNumber: passportCtrl.text.trim(),
                    dateOfBirth: dobCtrl.text.trim(),
                    nationality: nationalityCtrl.text.trim(),
                    passportIssued: issuedCtrl.text.trim(),
                    passportExpiry: expiryCtrl.text.trim(),
                    licenseNumber: licenseCtrl.text.trim(),
                    imageUrl: '',
                  );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('KYC qabul qilindi: ${nameCtrl.text} — Drivers bo\'limida ko\'ring')),
              );
            },
          ),
        ],
      );
    },
  );
}

Widget _field(TextEditingController c, String label, FleetThemeColors colors) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextField(
      controller: c,
      style: TextStyle(color: colors.textPrimary, decoration: TextDecoration.none),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.textMuted),
        filled: true,
        fillColor: colors.surfaceLight,
      ),
    ),
  );
}
