# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg desktop systemd udev

DESCRIPTION="Platform independent instrument control for Zurich Instruments devices"
HOMEPAGE="https://www.zhinst.com/labone"
SRC_URI="https://www.zhinst.com/sites/default/files/media/release_file/2021-09/LabOneLinux64-${PV}.tar.gz"

LICENSE="zi-labone"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="mirror bindist"
IUSE="minimal"

QA_PREBUILT="*"

RDEPEND=""

S=${WORKDIR}/LabOneLinux64-${PV}

src_install() {
	local application_directory=/opt/zi
	local installation_directory="${application_directory}/LabOne64-${PV}"

	if ! use minimal ; then

		# the applications

		dodir ${installation_directory}
		for dir in API DataServer Firmware Documentation WebServer ; do
			mv "$dir" "${D}${installation_directory}/" || die
		done

		cp "release_notes_$(ver_cut 1-2).txt" "${D}${installation_directory}/" || die

		dosym ../..${installation_directory}/DataServer/ziServer /opt/bin/ziServer
		dosym ../..${installation_directory}/DataServer/ziDataServer /opt/bin/ziDataServer

		# the services

		# LabOne comes with systemd support.

		local service
		for service in labone-data-server hf2-data-server ; do
			sed -e 's:/usr/local/bin/:/opt/bin/:g' -i Installer/systemd/${service}.service || die
			systemd_dounit Installer/systemd/${service}.service
		done

		# For OpenRC we need to do our own thing...

		for service in labone-data-server hf2-data-server ; do
			doinitd "${FILESDIR}/${service}"
			doconfd "${FILESDIR}/${service}.conf"
		done

		echo "#!/bin/bash" > "${T}/startziWebServer" || die
		echo "${installation_directory}/WebServer/ziWebServer -r ${installation_directory}/WebServer/html --ip 127.0.0.1 --server-port 8004 -a 1" '$@ &' >> "${T}/startziWebServer" || die
		chmod 755 "${T}/startziWebServer" || die
		exeinto /opt/bin
		doexe "${T}/startziWebServer"
		elog For security reasons the startziWebServer script listens on the localhost interface only.

		newicon "${D}${installation_directory}/WebServer/html/images/favicons/firefox_app_128x128.png" zi-labone.png

		make_desktop_entry /opt/bin/startziWebServer "ZI LabOne" zi-labone "Science;Physics;Engineering"

	else

		insinto "${installation_directory}/API/C/lib"
		doins API/C/lib/*.so
		insinto "${installation_directory}/API/C/include"
		doins API/C/include/*.h

	fi

	dosym "../..${installation_directory}/API/C/include/ziAPI.h" "usr/include/ziAPI.h"
	dosym "../..${installation_directory}/API/C/lib/libziAPI-linux64.so" "usr/$(get_libdir)/libziAPI-linux64.so"

	udev_dorules Installer/udev/55-zhinst.rules
}
