<?php

namespace App\DataTables;

use App\Models\WalletHistory;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Html\Editor\Editor;
use Yajra\DataTables\Html\Editor\Fields;
use Yajra\DataTables\Services\DataTable;

use App\Traits\DataTableTrait;

class WalletHistoryDataTable extends DataTable
{
    use DataTableTrait;
    /**
     * Build DataTable class.
     *
     * @param mixed $query Results from query() method.
     * @return \Yajra\DataTables\DataTableAbstract
     */
    public function dataTable($query)
    {
        return datatables()
            ->eloquent($query)
            ->editColumn('status', function($query) {
                $status = 'warning';
                switch ($query->type) {
                    case 'credit':
                        $status = 'success';
                        $status_label =  __('message.active');
                        break;
                    case 0:
                        $status = 'danger';
                        $status_label =  __('message.inactive');
                        break;
                    default:
                        $status_label = null;
                        break;
                }
                return '<span class="text-capitalize badge bg-'.$status.'">'.$status_label.'</span>';
            })
            
            ->editColumn('amount' , function ( $query ) {
                $amount = getPriceFormat( $query->amount ) ?? 0;

                $color = 'warning';
                if( $query->type == 'credit' ) {
                    $color = 'success';
                }
                return '<span class="text-capitalize badge bg-'.$color.'">'.$amount.'</span>';
            })
            
            ->editColumn('ride_request_id' , function ( $query ) {
                if( $query->ride_request_id != null ) {
                    return '<a href="'.route('riderequest.show', $query->ride_request_id ) .'" ># '.$query->ride_request_id.'</a>';
                } else {
                    return '<span>-</span>';
                }
            })

            ->editColumn('user_id' , function ( $query ) {
                return $query->user_id != null ? optional($query->user)->display_name : '';
            })
            
            ->filterColumn('user_id', function( $query, $keyword ){
                $query->whereHas('user', function ($q) use($keyword){
                    $q->where('display_name', 'like' , '%'.$keyword.'%');
                });
            })

            ->editColumn('transaction_type' , function ( $query ) {
                return __('message.'.$query->transaction_type);
            })
            ->rawColumns([ 'ride_request_id', 'amount' ]);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\WalletHistory $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query()
    {
        $model = WalletHistory::query();

        if( $this->user_id != null ) {
            return $model->where('user_id', $this->user_id);
        } else {
            return $model->myWalletHistory();
        }
        return $this->applyScopes($model);
    }

    /**
     * Get columns.
     *
     * @return array
     */
    protected function getColumns()
    {
        return [
            Column::make('ride_request_id')->title( __('message.ride_request_id') ),
            Column::make('user_id')->title( __('message.name') ),
            Column::make('amount')->title( __('message.amount') ),
            Column::make('transaction_type')->title( __('message.transaction_type') ),
            Column::make('datetime')->title( __('message.datetime') ),
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'Payment_' . date('YmdHis');
    }
}
