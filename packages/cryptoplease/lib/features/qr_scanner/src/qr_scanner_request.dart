import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solana/solana.dart';
import 'package:solana/solana_pay.dart';

import 'qr_address_data.dart';

part 'qr_scanner_request.freezed.dart';

@freezed
class QrScannerRequest with _$QrScannerRequest {
  const factory QrScannerRequest.solanaPay(SolanaPayRequest request) =
      QrScannerSolanaPayRequest;

  const factory QrScannerRequest.address(QrAddressData addressData) =
      QrScannerAddressRequest;

  const QrScannerRequest._();

  static QrScannerRequest? parse(String code) {
    final address = QrAddressData.tryParse(code);
    if (address != null) {
      return QrScannerRequest.address(address);
    } else {
      final request = SolanaPayRequest.tryParse(code);
      if (request != null) {
        return QrScannerRequest.solanaPay(request);
      }
    }
  }

  Ed25519HDPublicKey get recipient => map(
        solanaPay: (r) => r.request.recipient,
        address: (r) => r.addressData.address,
      );

  Ed25519HDPublicKey? get reference => whenOrNull<Ed25519HDPublicKey?>(
        solanaPay: (r) => r.reference?.firstOrNull,
      );
}