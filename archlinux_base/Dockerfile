FROM scratch
ADD archlinux_base.tar /
RUN git clone https://github.com/epl-viz/wireshark.git /opt/wireshark
RUN bash -c 'export PATH="${PATH}:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl";\
            cd /opt/wireshark; git submodule update --init --recursive;\
            mkdir build; cd build;\
            cmake -DCMAKE_INSTALL_PREFIX=/EPL -DCMAKE_INSTALL_MESSAGE=NEVER -DENABLE_HTML_GUIDES=OFF -DENABLE_SMI=OFF -DENABLE_GCRYPT=OFF -DENABLE_GNUTLS=OFF -DENABLE_KERBEROS=OFF -DENABLE_CARES=OFF -DENABLE_ZLIB=OFF -DENABLE_NETLINK=OFF -DENABLE_SBC=OFF -DENABLE_CAP=OFF -DENABLE_LUA=OFF -DENABLE_GEOIP=OFF -DENABLE_CODE_ANALYSIS=OFF -DENABLE_AIRPCAP=OFF -DBUILD_wireshark_gtk=OFF -DBUILD_wireshark=OFF ..;\
            make -j8;'
