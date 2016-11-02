# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils systemd unpacker

# Major version
MV=${PV/\.*}
MY_PN=${PN}${MV}
DESCRIPTION="All-In-One Solution for Remote Access and Support over the Internet"
HOMEPAGE="https://www.teamviewer.com"
SRC_URI="https://download.teamviewer.com/download/version_${MV}x/${PN}_${PV}_i386.deb"

IUSE="+system-wine"

LICENSE="TeamViewer LGPL-2.1" #LGPL for bundled wine
SLOT=${MV}
KEYWORDS="-* ~amd64 ~x86"

RESTRICT="bindist mirror"

RDEPEND="
	system-wine? ( app-emulation/wine[abi_x86_32(-),png] )
	!system-wine? ( media-libs/libpng:1.2[abi_x86_32(-)] )
	sys-apps/dbus[abi_x86_32(-)]
	dev-qt/qtcore:4[abi_x86_32(-)]
	dev-qt/qtgui:4[abi_x86_32(-)]
	dev-qt/qtwebkit:4[abi_x86_32(-)]
	media-libs/alsa-lib[abi_x86_32(-)]
	x11-libs/libICE[abi_x86_32(-)]
	x11-libs/libSM[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXau[abi_x86_32(-)]
	x11-libs/libXdamage[abi_x86_32(-)]
	x11-libs/libXdmcp[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXfixes[abi_x86_32(-)]
	x11-libs/libXrandr[abi_x86_32(-)]
	x11-libs/libXtst[abi_x86_32(-)]"

QA_PREBUILT="opt/teamviewer${MV}/*"

S=${WORKDIR}/opt/teamviewer/tv_bin

src_prepare() {
	#epatch "${FILESDIR}/${P}-gentoo.patch"
	sed \
		-e "s/@TVV@/${MV}/g" \
		"${FILESDIR}"/${PN}d.init > "${T}"/init || die
	sed \
		-e "s:/opt/teamviewer:/opt/teamviewer${MV}:g" \
		"script//${PN}d.service" > "${T}/${PN}d.service" || die
	sed \
		-e "s/@TVV@/${PV}/g" \
		-e "s/@TVMV@/${MV}/g" \
		"${FILESDIR}"/${PN}.sh > "${T}"/sh || die
	if ! use system-wine; then
		sed -i "s/native=true/native=false/g" "${T}/sh" || die
	fi
}

src_install () {
	local destdir="/opt/${MY_PN}"

	# install wine prefix skeleton and reg keys
	insinto "${destdir}/wine/drive_c/"
	doins -r wine/drive_c/TeamViewer/
	# install bundled wine if necessary
	if ! use system-wine; then
		insinto "${destdir}/tv_bin/wine"
		doins -r wine/{lib,share}
		exeinto "${destdir}/tv_bin/wine/bin"
		doexe wine/bin/{wine,wine-preloader,wineserver}
	fi
	# fix permissions
	fperms 755 ${destdir}/wine/drive_c/TeamViewer/TeamViewer.exe

	# install wine wrapper
	exeinto "/opt/bin"
	newexe "${T}/sh" "${MY_PN}"

	# install teamviewer linux binaries
	exeinto "${destdir}/tv_bin"
	doexe TeamViewer_Desktop TVGuiDelegate TVGuiSlave.32
	use amd64 && doexe TVGuiSlave.64

	# install daemon binary and scripts
	exeinto "${destdir}/tv_bin"
	doexe ${PN}d
	newinitd "${T}/init" ${PN}d${MV}
	newconfd "${FILESDIR}/${PN}d.conf" ${PN}d${MV}
	systemd_newunit "${T}/${PN}d.service" ${PN}d${MV}.service

	# set up logdir
	keepdir /var/log/${MY_PN}
	dosym /var/log/${MY_PN} /opt/${MY_PN}/logfiles

	# set up config dir
	keepdir /etc/${MY_PN}
	dosym /etc/${MY_PN} /opt/${MY_PN}/config

	newicon -s 48 desktop/${PN}.png ${MY_PN}.png
	#dodoc ../doc/linux_FAQ_{EN,DE}.txt
	make_desktop_entry ${MY_PN} "TeamViewer ${MV}" ${MY_PN}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog "TeamViewer from upstream uses an overly-complicated set of bash"
	elog "scripts to start the program.  This has been simplified for Gentoo"
	elog "use.  Any issues should be reported via bugzilla."
	if use system-wine; then
		elog
		elog "Due to bug #552016, when using system wine, one is not able to"
		elog "share one's own screen.  At this time, this may be remedied by"
		elog "toggling the system-wine USE flag."
	fi
	elog
	elog "The end-user client requires running the accompanying daemon,"
	elog "available via init-scripts."
}

pkg_postrm() {
	gnome2_icon_cache_update
}
