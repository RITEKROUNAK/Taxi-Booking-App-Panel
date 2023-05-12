<div class="modal-dialog" role="document">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">{{ $title }}</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="modal-body">
            <div class="row">
                <div class="col-md-12">
                    <table class="table dataTable table-responsive-sm table-borderless">
                        <tbody>
                            <tr>
                                <td><strong>{{ __('message.bank_name')}}</strong> </td>
                                <td><strong>:</strong> </td>
                                <td> <span> {{ $data->bank_name ?? '-' }}</span> </td>
                            </tr>
                            <tr>
                                <td><strong>{{ __('message.bank_code')}}</strong> </td>
                                <td><strong>:</strong> </td>
                                <td> <span> {{ $data->bank_code ?? '-' }}</span> </td>
                            </tr>
                            <tr>
                                <td><strong>{{ __('message.account_holder_name')}}</strong> </td>
                                <td><strong>:</strong> </td>
                                <td> <span>{{ $data->account_holder_name ?? '-' }}</span> </td>
                            </tr>
                            <tr>
                                <td><strong>{{ __('message.account_number')}}</strong> </td>
                                <td><strong>:</strong> </td>
                                <td> <span> {{ $data->account_number ?? '-'  }}</span> </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-md btn-secondary" data-dismiss="modal">{{ __('message.close') }}</button>
        </div>
    </div>
</div>