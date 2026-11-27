import pandas as pd

busstops = pd.read_csv('application/data/busstops.txt')

#5.6, #5.3 E
#51.6, #51.4 N
nonparent = busstops[busstops['parent_station'].isna()]
busstops = busstops.drop_duplicates(
    subset=['parent_station'])
busstops = pd.concat([nonparent, busstops], axis=0, join='outer', ignore_index=True)

busstops = busstops.loc[(busstops['stop_lat'] > 51.4) &
             (busstops['stop_lat'] < 51.6) &
             (busstops['stop_lon'] > 5.3) &
             (busstops['stop_lon'] < 5.6)
             ].drop(columns=['wheelchair_boarding',
                             'stop_timezone',
                             'platform_code',
                             'location_type',
                             'stop_name',
                             'stop_code',
                             'stop_ifopt',
                             'zone_id',
                             'parent_station']
            )
busstops = busstops.sort_values(by=['stop_lat', 'stop_lon']).reset_index(drop=True).to_excel('busstopssimple.xlsx')
