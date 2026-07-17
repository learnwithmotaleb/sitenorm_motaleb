import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

IconData getDeterminationIcon(String? determination) {
  switch (determination?.toLowerCase()) {
    case 'positive':
    case 'success':
    case 'passed':
    case 'good':
      return Icons.check_circle_outline;

    case 'negative':
    case 'failed':
    case 'danger':
    case 'bad':
      return Icons.cancel_outlined;

    case 'warning':
    case 'caution':
      return Icons.warning_amber_outlined;

    case 'pending':
    case 'processing':
      return Icons.pending_outlined;

    case 'excellent':
      return Icons.star_outline;

    case 'average':
    case 'normal':
      return Icons.info_outline;

    case 'insufficient data':
    case 'unknown':
    default:
      return Icons.cloud_outlined;
  }
}