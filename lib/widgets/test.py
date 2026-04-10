path('expense_data/', ExpenseAPIView.as_view(), name='expense-data-list-create'),
    path('expense_data/<int:pk>/', ExpenseAPIView.as_view(), name='expense-data-list-create'),

class ExpenseAPIView(BaseCRUDAPIView):
    model = Expense
    serializer_class = ExpenseSerializer

    def post(self, request, *args, **kwargs):
        client_code = self.validate_client_code(request)
        data = request.data.copy()

        # ✅ Auto-generate expense_id
        if 'expense_id' not in data:
            data['expense_id'] = get_expense_id(Expense, 'expense_id')

        if hasattr(self.model, 'client_code') and 'client_code' not in data:
            data['client_code'] = client_code

        serializer = self.serializer_class(data=data)
        if serializer.is_valid():
            serializer.save(created_by=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ExpenseEntryAPIView(BaseCRUDAPIView):
    model = ExpenseEntry
    serializer_class = ExpenseEntrySerializer

    def post(self, request, *args, **kwargs):
        client_code = self.validate_client_code(request)
        data = request.data.copy()

        # ✅ Auto-generate expense_id
        if 'expense_entry_id' not in data:
            data['expense_entry_id'] = get_expense_entry_id(ExpenseEntry, 'expense_entry_id')

        if hasattr(self.model, 'client_code') and 'client_code' not in data:
            data['client_code'] = client_code

        serializer = self.serializer_class(data=data)
        if serializer.is_valid():
            expense_entry = serializer.save(created_by=request.user)

            expense = expense_entry.expense
            if expense and expense_entry.amount:
                expense.open_balance = (expense.open_balance or 0) + expense_entry.amount
                expense.save(update_fields=['open_balance'])

            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk, format=None):
        client_code = self.validate_client_code(request)

        instance = self.get_object(pk, client_code)
        if not instance:
            return Response({"detail": f"{self.model.__name__} not found"}, status=status.HTTP_404_NOT_FOUND)

        # Create mutable copy of request data
        data = request.data.copy()
        if hasattr(self.model, 'client_code') and 'client_code' not in data:
            data['client_code'] = client_code

        # 🔹 Force is_updated=True
        if hasattr(self.model, 'is_updated'):
            data['is_updated'] = True

        serializer = self.serializer_class(instance, data=data)
        if serializer.is_valid():
            expense_entry = serializer.save()

            expense = expense_entry.expense
            if expense and expense_entry.amount:
                expense.open_balance = (expense.open_balance or 0) + expense_entry.amount
                expense.save(update_fields=['open_balance'])

            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, pk, format=None):
        client_code = self.validate_client_code(request)

        instance = self.get_object(pk, client_code)
        if not instance:
            return Response({"detail": f"{self.model.__name__} not found"}, status=status.HTTP_404_NOT_FOUND)

        # Create mutable copy of request data
        data = request.data.copy()
        if hasattr(self.model, 'client_code') and 'client_code' not in data:
            data['client_code'] = client_code

        # 🔹 Force is_updated=True
        if hasattr(self.model, 'is_updated'):
            data['is_updated'] = True

        serializer = self.serializer_class(instance, data=data, partial=True)
        if serializer.is_valid():
            expense_entry = serializer.save()
            expense = expense_entry.expense
            if expense and expense_entry.amount:
                expense.open_balance = (expense.open_balance or 0) + expense_entry.amount
                expense.save(update_fields=['open_balance'])
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

\