# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit multilib python-single-r1

MY_PN=IceWMControlPanel
DESCRIPTION="A complete control panel for IceWM using gtk & python"
HOMEPAGE="http://icesoundmanager.sourceforge.net/index.php"
SRC_URI="mirror://sourceforge/icesoundmanager/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	dev-python/pygtk:2
	x11-libs/gtk+:2
	x11-wm/icewm
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/INSTALL-IceWMCP

src_prepare() {
	rm -rf licenses
	mv doc .. || die
}

src_install() {
	local dest="/usr/$(get_libdir)/${P}"
	insinto ${dest}
	doins -r *

	local w wraps=(
		"IceWMCP.py IceWMCP"
		"IceWMCPKeyboard.py IceWMCP-Keyboard"
		"IceWMCPMouse.py IceWMCP-Mouse"
		"pyspool.py IceWMCP-PySpool"
		"IceWMCPWallpaper.py IceWMCP-Wallpaper"
		"IceWMCPWinOptions.py IceWMCP-WinOptions"
		"phrozenclock.py PhrozenClock"
		"icesound.py IceSoundManager"
		"IceWMCP_GtkPCCard.py GtkPCCard"
		"IceMe.py iceme"
		"icepref.py icepref"
		"icepref_td.py icepref_td"
		"IceWMCPGtkIconSelection.py IceWMCP-Icons"
		"IceWMCPEnergyStar.py IceWMCP-EnergyStar"
	)
	for w in "${wraps[@]}" ; do
		set -- ${w}
		printf '#!/bin/sh\nexec %s %s/%s\n' "${EPYTHON}" "${dest}" "$1" > "${T}"/$2
		dobin "${T}"/$2
	done

	dodoc ../doc/*.txt
	dohtml ../doc/*.html
	python_optimize "${D}/${dest}"
}
