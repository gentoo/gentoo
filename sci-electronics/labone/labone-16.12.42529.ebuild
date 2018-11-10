# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Platform independent instrument control for Zurich Instruments devices"
HOMEPAGE="https://www.zhinst.com/labone"
SRC_URI="https://www.zhinst.com/system/files/downloads/files/LabOneLinux64-${PV}.tar.gz"

LICENSE="zi-labone"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="mirror bindist"
IUSE="minimal"

QA_PREBUILT="*"

RDEPEND=""

S=${WORKDIR}/LabOneLinux64-${PV}

src_install() {
	local instPath=/opt/zi
	local instrDir="LabOne64-${PV}"

	if ! use minimal ; then

		dodir ${instPath}/${instrDir}
		for dir in API DataServer Documentation WebServer release_notes_16.12.txt ; do
			cp -a "$dir" "${D}${instPath}/${instrDir}/" || die
		done

		dosym ../..${instPath}/${instrDir}/DataServer/ziServer /opt/bin/ziServer
		dosym ../..${instPath}/${instrDir}/DataServer/ziDataServer /opt/bin/ziDataServer

		echo "#!/bin/bash" > "${T}/startWebServer" || die
		echo "${instPath}/${instrDir}/WebServer/ziWebServer -r ${instPath}/${instrDir}/WebServer/html --ip 127.0.0.1 --server-port 8004" >> "${T}/startWebServer" || die
		chmod 755 "${T}/startWebServer" || die
		exeinto /opt/bin
		doexe "${T}/startWebServer"
		elog For security reasons the startWebServer script listens on the localhost interface only.
	else

		insinto "${instPath}/${instrDir}/API/C/lib"
		doins API/C/lib/*.so
		insinto "${instPath}/${instrDir}/API/C/include"
		doins API/C/include/*.h

	fi

	dosym "../..${instPath}/${instrDir}/API/C/include/ziAPI.h" "usr/include/ziAPI.h"
	dosym "../..${instPath}/${instrDir}/API/C/lib/libziAPI-linux64.so" "usr/$(get_libdir)/libziAPI-linux64.so"

	# the udev integration

	sed -e 's:/usr/bin/ziServer:/opt/bin/ziServer:g' -i Installer/udev/config || die
	insinto /etc/ziService
	doins Installer/udev/config
	sed -e 's:/usr/bin/ziServer:/opt/bin/ziServer:g' -i Installer/udev/55-zhinst.rules || die
	insinto /lib/udev/rules.d
	doins Installer/udev/55-zhinst.rules
	exeinto /opt/bin
	doexe Installer/udev/ziService

	# just to make sure
	dosym ../../opt/bin/ziService usr/bin/ziService
}

pkg_prerm() {
	if [[ -x /opt/bin/ziService ]]; then
		einfo "Stopping ziService for safe unmerge"
		/opt/bin/ziService stop
	fi
}
