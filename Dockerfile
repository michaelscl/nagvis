FROM chialab/php:7.2-apache

ENV NAGVIS 1.9.11
ENV SOCKET unix:/opt/nagios/var/rw/live

RUN apt-get update && apt-get install -y \
    mc wget \
    sqlite3 graphviz aptitude && \
    apt-get clean && rm -Rf /var/lib/apt/lists/*


RUN cd /tmp && \
    wget -O nagvis.tar.gz http://www.nagvis.org/share/nagvis-${NAGVIS}.tar.gz && \
    tar zxvf nagvis.tar.gz && \
    mv nagvis-${NAGVIS} nagvis && \
    rm -f nagvis.tar.gz && \
    cd nagvis && \
    ./install.sh -s /opt/nagvis -n /opt/nagios/ -b /usr/bin -p /usr/local/nagvis \
       -W /nagvis -u www-data -g www-data -w /etc/apache2/conf-available -i mklivestatus -l ${SOCKET} -a y -q && \
    a2enconf nagvis && \
    cd .. && \
    rm -Rf nagvis && \
    chmod -R a+w /usr/local/nagvis/var && \
    chmod -R a+w /usr/local/nagvis/etc
