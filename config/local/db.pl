+{
    connect_info => {
        USER_MASTER => {
            dsn      => 'dbi:mysql:dbname=mayoi;host=localhost',
            user     => 'root',
            password => '',
            attrs    => +{ RaiseError => 1, AutoCommit => 0 },
        },
        USER_SLAVE => {
            dsn      => 'dbi:mysql:dbname=mayoi;host=localhost',
            user     => 'root',
            password => '',
            attrs    => +{ RaiseError => 1, AutoCommit => 1 },
        },
    },
}
