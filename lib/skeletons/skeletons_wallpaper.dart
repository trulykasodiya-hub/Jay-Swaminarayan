
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

Widget skeletonsWallpaper() {
  return const SkeletonAvatar(
    style: SkeletonAvatarStyle(
      width: double.infinity,
      minHeight: 160,
      maxHeight: 180,
    ),
  );
}

Widget skeletonsSuvichar() {
  return const SkeletonAvatar(
    style: SkeletonAvatarStyle(
      width: double.infinity,
      minHeight: 105,
      maxHeight: 120,
    ),
  );
}
