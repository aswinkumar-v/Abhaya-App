import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AbhayaScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Color backgroundColor;
  final bool resizeToAvoidBottomInset;

  const AbhayaScaffold({
    super.key,
    required this.body,
    this.title,
    this.subtitle,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.bottomNavigationBar,
    this.backgroundColor = AppColors.bg,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: (title != null || showBack)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: (showBack && canPop)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: Center(
                        child: InkWell(
                          onTap: onBack ?? () => Navigator.maybePop(context),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.line),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.ink.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              title: title == null
                  ? null
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title!,
                          style: AppTextStyles.h3.copyWith(fontSize: 16),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: AppTextStyles.caption.copyWith(fontSize: 11),
                          ),
                        ],
                      ],
                    ),
              actions: actions != null
                  ? [
                      ...actions!,
                      const SizedBox(width: 8),
                    ]
                  : null,
            )
          : null,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
