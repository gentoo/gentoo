# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
PYTHON_DEPEND="2"

inherit python multilib

S=${WORKDIR}/INSTALL-IceWMCP
MY_PN=IceWMControlPanel
MY_DEST="usr/$(get_libdir)/${P}"
MY_BIN="usr/bin"

DESCRIPTION="A complete control panel for IceWM using gtk & python"
HOMEPAGE="http://icesoundmanager.sourceforge.net/index.php"
SRC_URI="mirror://sourceforge/icesoundmanager/${MY_PN}-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc x86"
IUSE=""
DEPEND="x11-wm/icewm
		dev-python/pygtk:2
		x11-libs/gtk+:2"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	dodir "${MY_DEST}/"
	dodir "${MY_BIN}/"
	dodoc "${S}"/doc/* "${S}"/licenses/*
	cp "${S}"/* "${D}"/${MY_DEST}
	cp -R "${S}"/applets "${S}"/applet-icons "${S}"/help "${S}"/icons \
	"${S}"/locale "${S}"/pixmaps "${D}"/${MY_DEST}/
	# create executable shortcuts to the python scripts
	echo -e "#!/bin/bash \n python /${MY_DEST}/IceWMCP.py" > ${T}/IceWMCP
	echo -e "#!/bin/bash \n python /${MY_DEST}/IceWMCPKeyboard.py" > ${T}/IceWMCP-Keyboard
	echo -e "#!/bin/bash \n python /${MY_DEST}/IceWMCPMouse.py" > ${T}/IceWMCP-Mouse
	echo -e "#!/bin/bash \n python /${MY_DEST}/pyspool.py" > ${T}/IceWMCP-PySpool
	echo -e "#!/bin/bash \n python /${MY_DEST}/IceWMCPWallpaper.py" > ${T}/IceWMCP-Wallpaper
	echo -e "#!/bin/bash \n python /${MY_DEST}/IceWMCPWinOptions.py" > ${T}/IceWMCP-WinOptions
	echo -e "#!/bin/bash \n python /${MY_DEST}/phrozenclock.py" > ${T}/PhrozenClock
	echo -e "#!/bin/bash \n python /${MY_DEST}/icesound.py" > ${T}/IceSoundManager
	echo -e "#!/bin/bash \n python /${MY_DEST}/IceWMCP_GtkPCCard.py" > ${T}/GtkPCCard
	echo -e "#!/bin/bash \n python /${MY_DEST}/IceMe.py" > ${T}/iceme
	echo -e "#!/bin/bash \n python /${MY_DEST}/icepref.py" > ${T}/icepref
	echo -e "#!/bin/bash \n python /${MY_DEST}/icepref_td.py" > ${T}/icepref_td
	echo -e "#!/bin/bash \n python /${MY_DEST}/IceWMCPGtkIconSelection.py" > ${T}/IceWMCP-Icons
	echo -e "#!/bin/bash \n python /${MY_DEST}/IceWMCPEnergyStar.py" > ${T}/IceWMCP-EnergyStar
	dobin "${T}"/*
}

pkg_postinst() {
	einfo "Some of the icons displayed by IceWMCP may be pointing to"
	einfo "programs which are not on your system!  You can hide them"
	einfo "using the Configuration window (Ctrl+C) or change them"
	einfo "by editing the files in"
	einfo "/${MY_DEST}/applets and"
	einfo "/${MY_DEST}/applet-icons."
}
