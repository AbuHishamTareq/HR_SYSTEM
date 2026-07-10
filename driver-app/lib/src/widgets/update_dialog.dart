import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shows a modal dialog prompting the user to update the app.
///
/// When [isForceUpdate] is true, the dialog cannot be dismissed (no back button,
/// no barrier dismiss). The user MUST update to continue.
Future<void> showUpdateDialog({
  required BuildContext context,
  required bool isForceUpdate,
  required String storeUrl,
}) {
  return showDialog(
    context: context,
    barrierDismissible: !isForceUpdate,
    builder: (context) => PopScope(
      canPop: !isForceUpdate,
      child: AlertDialog(
        title: Row(
          children: [
            Icon(
              isForceUpdate ? Icons.warning_amber_rounded : Icons.system_update,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                isForceUpdate ? 'Update Required' : 'Update Available',
              ),
            ),
          ],
        ),
        content: Text(
          isForceUpdate
              ? 'A new version of the app is required to continue. Please update now.'
              : 'A new version of the app is available. Would you like to update?',
        ),
        actions: [
          if (!isForceUpdate)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Later'),
            ),
          FilledButton(
            onPressed: () {
              final uri = Uri.tryParse(storeUrl);
              if (uri != null) {
                launchUrl(uri, mode: LaunchMode.externalApplication);
              }
              if (!isForceUpdate) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    ),
  );
}
