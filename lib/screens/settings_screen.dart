import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, settingsVm, _) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: const Text(
                    'Settings',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.accentCyan.withAlpha(30),
                          AppTheme.bgDark,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Generation Settings
                      _buildSectionHeader('Generation'),
                      const SizedBox(height: 12),

                      // Temperature
                      _buildSliderCard(
                        icon: Icons.thermostat_rounded,
                        title: 'Temperature',
                        subtitle: 'Controls randomness/creativity',
                        value: settingsVm.temperature,
                        min: 0.0,
                        max: 2.0,
                        divisions: 20,
                        label: settingsVm.temperature.toStringAsFixed(1),
                        onChanged: settingsVm.setTemperature,
                      ),
                      const SizedBox(height: 8),

                      // Max Tokens
                      _buildSliderCard(
                        icon: Icons.text_fields_rounded,
                        title: 'Max Tokens',
                        subtitle: 'Maximum response length',
                        value: settingsVm.maxTokens.toDouble(),
                        min: 128,
                        max: 4096,
                        divisions: 31,
                        label: settingsVm.maxTokens.toString(),
                        onChanged: (v) => settingsVm.setMaxTokens(v.toInt()),
                      ),
                      const SizedBox(height: 8),

                      // Top P
                      _buildSliderCard(
                        icon: Icons.tune_rounded,
                        title: 'Top P',
                        subtitle: 'Nucleus sampling threshold',
                        value: settingsVm.topP,
                        min: 0.1,
                        max: 1.0,
                        divisions: 9,
                        label: settingsVm.topP.toStringAsFixed(1),
                        onChanged: settingsVm.setTopP,
                      ),
                      const SizedBox(height: 8),

                      // Repeat Penalty
                      _buildSliderCard(
                        icon: Icons.replay_rounded,
                        title: 'Repeat Penalty',
                        subtitle: 'Penalizes repeated tokens',
                        value: settingsVm.repeatPenalty,
                        min: 1.0,
                        max: 2.0,
                        divisions: 10,
                        label: settingsVm.repeatPenalty.toStringAsFixed(1),
                        onChanged: settingsVm.setRepeatPenalty,
                      ),

                      const SizedBox(height: 24),
                      _buildSectionHeader('System Prompt'),
                      const SizedBox(height: 12),

                      // System Prompt
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.cardGradient,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: TextField(
                          maxLines: 4,
                          controller: TextEditingController(
                            text: settingsVm.systemPrompt,
                          ),
                          onChanged: settingsVm.setSystemPrompt,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter system instructions for the AI...',
                            hintStyle: const TextStyle(
                              color: AppTheme.textMuted,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 16, top: 16),
                              child: Align(
                                alignment: Alignment.topLeft,
                                widthFactor: 1,
                                heightFactor: 1,
                                child: Icon(
                                  Icons.edit_note_rounded,
                                  color: AppTheme.accentPurple.withAlpha(150),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      _buildSectionHeader('Actions'),
                      const SizedBox(height: 12),

                      // Reset button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppTheme.cardGradient,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: settingsVm.resetToDefaults,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppTheme.warning.withAlpha(30),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.restore_rounded,
                                      color: AppTheme.warning,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Reset to Defaults',
                                        style: TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Restore all settings to default values',
                                        style: TextStyle(
                                          color: AppTheme.textMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      // App info
                      Center(
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  AppTheme.accentGradient.createShader(bounds),
                              child: const Text(
                                'Local Chat AI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'v1.0.0 · Powered by llama.cpp',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accentPurple.withAlpha(20),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.accentPurple.withAlpha(40),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.developer_mode_rounded,
                                    size: 14,
                                    color: AppTheme.accentPurple,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Developer: Haris (haris1nabi@gmail.com)',
                                    style: TextStyle(
                                      color: AppTheme.accentPurple,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: AppTheme.textMuted,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSliderCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required Function(double) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.accentPurple, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.accentPurple,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
