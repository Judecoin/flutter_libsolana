// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_largest_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenLargestAccount _$TokenLargestAccountFromJson(Map<String, dynamic> json) =>
    TokenLargestAccount(
      address: json['address'] as String,
      amount: json['amount'] as String,
      decimals: json['decimals'] as int,
      uiAmountString: json['uiAmountString'] as String,
    );

TokenLargestAccountsResult _$TokenLargestAccountsResultFromJson(
        Map<String, dynamic> json) =>
    TokenLargestAccountsResult(
      context: Context.fromJson(json['context'] as Map<String, dynamic>),
      value: (json['value'] as List<dynamic>)
          .map((e) => TokenLargestAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
