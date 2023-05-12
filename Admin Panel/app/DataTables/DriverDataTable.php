<?php

namespace App\DataTables;

use App\Models\User;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Html\Editor\Editor;
use Yajra\DataTables\Html\Editor\Fields;
use Yajra\DataTables\Services\DataTable;

use App\Traits\DataTableTrait;

class DriverDataTable extends DataTable
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
                switch ($query->status) {
                    case 'active':
                        $status = 'primary';
                        break;
                    case 'inactive':
                        $status = 'danger';
                        break;
                    case 'banned':
                        $status = 'dark';
                        break;
                }
                return '<span class="text-capitalize badge bg-'.$status.'">'.$query->status.'</span>';
            })
            ->editColumn('is_verified_driver', function($driver) {

                $is_verified_driver = $driver->is_verified_driver;
                if( $is_verified_driver == '1' ){
                    $status = '<span class="badge badge-success">'.__('message.verified').'</span>';
                }else{
                    $status = '<span class="badge badge-warning">'.__('message.unverified').'</span>';
                }
                return $status;
            })
            ->editColumn('created_at', function($query) {
                return date('Y/m/d',strtotime($query->created_at));
            })

            ->editColumn('service_id' , function ( $query ) {
                return $query->service_id != null ? optional($query->service)->name : '';
            })

            ->filterColumn('service_id', function( $query, $keyword ){
                $query->whereHas('service', function ($q) use($keyword){
                    $q->where('name', 'like' , '%'.$keyword.'%');
                });
            })

            ->addIndexColumn()
            // ->addColumn('action', 'driver.action')
            ->addColumn('action', function($data){
                $id = $data->id;
                return view('driver.action',compact('data','id'))->render();
            })
            ->rawColumns(['action','status', 'is_verified_driver']);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\User $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query()
    {
        $model = User::where('user_type','driver');
        if(auth()->user()->hasRole('fleet')) {
            $model->where('fleet_id', auth()->user()->id);
        }

        if($this->status != null){
            // $model = $model->where('status', $this->status);
            $model = $model->where('status', '!=', 'active');
        } else {
            $model = $model->where('status','active');
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
            Column::make('DT_RowIndex')
                ->searchable(false)
                ->title(__('message.srno'))
                ->orderable(false)
                ->width(60),
            Column::make('display_name')->title( __('message.name') ),
            Column::make('contact_number'),
            Column::make('address'),
            Column::make('status'),
            Column::make('service_id')->title( __('message.service') ),
            Column::make('is_verified_driver')->title( __('message.is_verify') ),
            Column::computed('action')
                  ->exportable(false)
                  ->printable(false)
                  ->width(60)
                  ->addClass('text-center'),
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'driver_' . date('YmdHis');
    }
}
