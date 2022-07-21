import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:uuid/uuid.dart';

class ImageRepository {
  final Minio _s3;
  final String _bucketName;
  ImageRepository(this._s3, this._bucketName);

  Future<String> uploadImage({
    required String dirName,
    required String imageFileName,
    required String oldImageKey,
    required String selectImageFile,
  }) async {
    try {
      String uuid = const Uuid().v4(); // お好みでファイル名にuuidを連結

      if (oldImageKey.isNotEmpty) {
        // 更新の場合は上書き
        uuid = oldImageKey.split(imageFileName).last;
      }

      // ここで指定したobjectKeyが画像の保存先名称とオブジェクトキーになる
      // 更新したい時はターゲットのオブジェクトキーを指定すると画像が上書きされる
      final objectKey = '$dirName/$imageFileName$uuid';
      await _s3.fPutObject(
        _bucketName,
        objectKey,
        selectImageFile,
      );

      return objectKey; // オブジェクトキーをリターンしてあとはこれをDBに保存など
    } on Exception catch (e) {
      throw e.toString();
    }
  }
}