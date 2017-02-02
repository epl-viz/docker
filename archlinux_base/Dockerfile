FROM scratch
ADD archlinux_base.tar /
RUN git clone https://github.com/epl-viz/wireshark.git /opt/wireshark
RUN bash -c 'export PATH="${PATH}:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl";\
            cd /opt/wireshark; git submodule update --init --recursive;\
            mkdir build; cd build;\
            cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug -DENABLE_HTML_GUIDES=OFF -DENABLE_LUA=ON -DENABLE_GEOIP=ON ..;\
            make -j8;\
            umask 0022 && make install'
