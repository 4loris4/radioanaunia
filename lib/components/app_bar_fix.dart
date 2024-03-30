import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Fixes the splashRadius of the leading button of the normal AppBar
class AppBarFix extends StatelessWidget implements PreferredSizeWidget {
  AppBarFix({
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
    this.splashRadius = 24,
    super.key,
  }) : preferredSize = Size.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0));

  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final ScrollNotificationPredicate notificationPredicate;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final Clip? clipBehavior;
  final double? splashRadius;

  @override
  final Size preferredSize;

  Widget? _getLeading(BuildContext context) {
    if (!automaticallyImplyLeading) return null;

    final route = ModalRoute.of(context);
    final scaffold = Scaffold.maybeOf(context);
    final materialLocalizations = MaterialLocalizations.of(context);

    if (scaffold != null && scaffold.hasDrawer) {
      return IconButton(
        onPressed: scaffold.openDrawer,
        icon: const DrawerButtonIcon(),
        tooltip: materialLocalizations.drawerLabel,
        splashRadius: splashRadius,
      );
    }

    if (route is PageRoute && route.canPop) {
      return IconButton(
        onPressed: Navigator.of(context).maybePop,
        icon: route.fullscreenDialog ? const CloseButtonIcon() : const BackButtonIcon(),
        tooltip: route.fullscreenDialog ? materialLocalizations.closeButtonTooltip : materialLocalizations.backButtonTooltip,
        splashRadius: splashRadius,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ?? _getLeading(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      notificationPredicate: notificationPredicate,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      primary: primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle: systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      clipBehavior: clipBehavior,
    );
  }
}
