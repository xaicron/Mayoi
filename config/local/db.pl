+{
    connect_info => {
        MASTER => {
            dsn      => 'dbi:mysql:dbname=mayoi;host=localhost',
            user     => 'root',
            password => '',
            attrs    => +{ RaiseError => 1, AutoCommit => 0 },
        },
        SLAVE => {
            dsn      => 'dbi:mysql:dbname=mayoi;host=localhost',
            user     => 'root',
            password => '',
            attrs    => +{ RaiseError => 1, AutoCommit => 1 },
        },
    },
}
