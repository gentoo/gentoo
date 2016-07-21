# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils systemd unpacker

# Major version
MV=${PV/\.*}
MY_PN=${PN}${MV}
DESCRIPTION="All-In-One Solution for Remote Access and Support over the Internet"
HOMEPAGE="http://www.teamviewer.com"
SRC_URI="http://www.teamviewer.com/download/version_${MV}x/teamviewer_linux.deb -> ${P}.deb"

LICENSE="TeamViewer !system-wine? ( LGPL-2.1 )"
SLOT=${MV}
KEYWORDS="~amd64 ~x86"
IUSE="system-wine"

RESTRICT="mirror"

RDEPEND="
	app-shells/bash
	x11-misc/xdg-utils
	!system-wine? (
		media-libs/alsa-lib[abi_x86_32(-)]
		media-libs/freetype[abi_x86_32(-)]
		sys-libs/zlib[abi_x86_32(-)]
		x11-libs/libX11[abi_x86_32(-)]
		x11-libs/libXau[abi_x86_32(-)]
		x11-libs/libXdamage[abi_x86_32(-)]
		x11-libs/libXext[abi_x86_32(-)]
		x11-libs/libXfixes[abi_x86_32(-)]
		x11-libs/libXrandr[abi_x86_32(-)]
		x11-libs/libXrender[abi_x86_32(-)]
		x11-libs/libSM[abi_x86_32(-)]
		x11-libs/libXtst[abi_x86_32(-)]
	)
	system-wine? ( app-emulation/wine )"

QA_PREBUILT="opt/teamviewer${MV}/*"

S=${WORKDIR}/opt/teamviewer${MV}/tv_bin

make_winewrapper() {
	cat << EOF > "${T}/${MY_PN}"
#!/bin/sh
export WINEDLLPATH=/opt/${MY_PN}
exec wine "/opt/${MY_PN}/TeamViewer.exe" "\$@"
EOF
	chmod go+rx "${T}/${MY_PN}"
	exeinto /opt/bin
	doexe "${T}/${MY_PN}"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch

	sed \
		-e "s#@TVV@#${MV}/tv_bin#g" \
		"${FILESDIR}"/${PN}d${MV}.init > "${T}"/${PN}d${MV} || die
}

src_install () {
	if use system-wine ; then
		make_winewrapper
		exeinto /opt/${MY_PN}
		doexe wine/drive_c/TeamViewer/*
	else
		# install scripts and .reg
		insinto /opt/${MY_PN}/tv_bin
		doins -r *

		exeinto /opt/${MY_PN}/tv_bin
		doexe TeamViewer_Desktop
		exeinto /opt/${MY_PN}/tv_bin/script
		doexe script/teamviewer script/tvw_{aux,config,exec,extra,main,profile}

		dosym /opt/${MY_PN}/tv_bin/script/${PN} /opt/bin/${MY_PN}

		# fix permissions
		fperms 755 /opt/${MY_PN}/tv_bin/wine/bin/wine{,-preloader,server}
		fperms 755 /opt/${MY_PN}/tv_bin/wine/drive_c/TeamViewer/TeamViewer.exe
		find "${D}"/opt/${MY_PN} -type f -name "*.so*" -execdir chmod 755 '{}' \;
	fi

	# install daemon binary
	exeinto /opt/${MY_PN}/tv_bin
	doexe ${PN}d

	# set up logdir
	keepdir /var/log/${MY_PN}
	dosym /var/log/${MY_PN} /opt/${MY_PN}/logfiles

	# set up config dir
	keepdir /etc/${MY_PN}
	dosym /etc/${MY_PN} /opt/${MY_PN}/config

	doinitd "${T}"/${PN}d${MV}
	systemd_newunit script/${PN}d.service ${PN}d${MV}.service

	newicon -s 48 desktop/${PN}.png ${MY_PN}.png
	dodoc ../doc/linux_FAQ_{EN,DE}.txt
	make_desktop_entry ${MY_PN} TeamViewer ${MY_PN}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	if use system-wine ; then
		echo
		eerror "IMPORTANT NOTICE!"
		elog "Using ${PN} with system wine is not supported and experimental."
		elog "Do not report gentoo bugs while using this version."
		echo
	fi

	eerror "STARTUP NOTICE:"
	elog "You cannot start the daemon via \"teamviewer --daemon start\"."
	elog "Instead use the provided gentoo initscript:"
	elog "  /etc/init.d/${PN}d${MV} start"
	elog
	elog "Logs are written to \"/var/log/teamviewer${MV}\""
}

pkg_postrm() {
	gnome2_icon_cache_update
}
