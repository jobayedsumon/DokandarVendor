import 'package:dokandar_shop/features/expense/domain/models/expense_model.dart';

abstract class ExpenseServiceInterface {
  Future<ExpenseBodyModel?> getExpenseList({required int offset, required int? restaurantId, required String? from, required String? to,  required String? searchText});
}