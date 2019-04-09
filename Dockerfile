FROM bitwalker/alpine-elixir:1.8.0

RUN apk --no-cache  add -q postgresql postgresql-contrib openrc sudo build-base openssh


RUN mkdir /run/postgresql &&  chown -R postgres:postgres /run/postgresql

RUN echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user


USER postgres
RUN mkdir /var/lib/postgresql/data &&\
    chmod 0700 /var/lib/postgresql/data &&\
    initdb /var/lib/postgresql/data &&\
    echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf &&\
    echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf &&\
    pg_ctl start -D /var/lib/postgresql/data -o -s > /dev/null 2>&1 &&\
    psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = 'testdb'" | grep -q 1 || psql -U postgres -c "CREATE DATABASE testdb" &&\
    psql --command "ALTER USER postgres WITH ENCRYPTED PASSWORD 'pass1234';"



EXPOSE 5432 
