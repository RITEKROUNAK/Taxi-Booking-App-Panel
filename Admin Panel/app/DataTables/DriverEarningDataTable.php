<?php

namespace App\DataTables;

use App\Models\User;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Html\Editor\Editor;
use Yajra\DataTables\Html\Editor\Fields;
use Yajra\DataTables\Services\DataTable;

use App\Traits\DataTableTrait;

class DriverEarningDataTable extends DataTable
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

        ->editColumn('id' , function ( $query ) {
            if( auth()->user()->can('driver show') ) {
                return '<a href="'.route('driver.show', $query->id ) .'" title="'. __('message.view_form_title', ['form' => __('message.driver') ]).'" ># '.$query->id.'</a>';
            } else {
                return $query->id;
            }
        })
        ->editColumn('driver_commission', function ( $row ) {
            return getPriceFormat( $row->driver_commission ) ?? '-';
        })
        
        ->editColumn('admin_commission', function ( $row ) {
            return getPriceFormat( $row->admin_commission) ?? '-';
        })

        ->editColumn('total_withdrawn', function ( $row ) {
            return getPriceFormat( $row->total_withdrawn ) ?? '-';
        })

        ->editColumn('wallet_balance', function ( $row ) {
            return getPriceFormat( $row->wallet_balance ) ?? '-';
        })
        ->rawColumns([ 'id' ]);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\User $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query()
    {
        $model = User::select('users.id','users.display_name')->where('user_type','driver')->has('driverRideRequestDetail')
            ->with(['getPayment:ride_request_id,driver_commission,admin_commission', 'userWallet:total_amount,total_withdrawn'])
            ->withSum('userWallet as wallet_balance', 'total_amount')
            ->withSum('userWallet as total_withdrawn', 'total_withdrawn')
            ->withSum('getPayment as driver_commission', 'driver_commission')
            ->withSum('getPayment as admin_commission', 'admin_commission');
            
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
            Column::make('id')->title( '#' ),
            Column::make('display_name')->title( __('message.name') ),
            Column::make('driver_commission')->title( __('message.driver_earning') )->searchable(false),
            Column::make('admin_commission')->title( __('message.admin_commission') )->searchable(false),
            Column::make('wallet_balance')->title( __('message.wallet_balance') )->searchable(false),
            Column::make('total_withdrawn')->title( __('message.total_withdraw') )->searchable(false),
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'DriverEarning_' . date('YmdHis');
    }
}
