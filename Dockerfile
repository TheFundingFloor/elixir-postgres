FROM fundingfloor/tff-elixir:1.8

RUN apk --no-cache  add -q postgresql postgresql-contrib openrc


RUN mkdir /run/postgresql &&  chown -R postgres:postgres /run/postgresql
USER postgres
RUN mkdir /var/lib/postgresql/data &&\
    chmod 0700 /var/lib/postgresql/data &&\
    initdb /var/lib/postgresql/data &&\
    echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf &&\
    echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf &&\
    pg_ctl start -D /var/lib/postgresql/data -o -s &&\
    psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = 'testdb'" | grep -q 1 || psql -U postgres -c "CREATE DATABASE testdb" &&\
    psql --command "ALTER USER postgres WITH ENCRYPTED PASSWORD 'pass1234';"



EXPOSE 5432 
