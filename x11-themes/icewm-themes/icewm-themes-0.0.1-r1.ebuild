# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/icewm-themes/icewm-themes-0.0.1-r1.ebuild,v 1.12 2011/08/24 18:42:50 xarthisius Exp $

DESCRIPTION="Collection of IceWM themes"
HOMEPAGE="http://www.icewm.org/
	http://themes.freshmeat.net/projects/icecrack/
	http://themes.freshmeat.net/projects/icebox/
	http://themes.freshmeat.net/projects/cyrusicewm/
	http://themes.freshmeat.net/projects/greyscaled/
	http://themes.freshmeat.net/projects/ufosightings/
	http://themes.freshmeat.net/projects/1in1-xp/"
THEME_URI="http://download.freshmeat.net/themes"
SRC_URI="${THEME_URI}/icecrack/icecrack-default-2.0.0.tar.gz
	${THEME_URI}/icebox-red/icebox-red-default-1.2.13.tar.gz
	${THEME_URI}/cyrusicewm/cyrusicewm-1.0.0.tar
	${THEME_URI}/greyscaled/greyscaled-stable.tar.gz
	${THEME_URI}/ufosightings/ufosightings-1.0.0.tar.gz
	${THEME_URI}/1in1-xp/1in1-xp-default.tar.gz"

# icecrack, icebox, cyrus-icewm, ufosightings -> GPL-2
# greyscaled -> Public Domain
# 1in1-xp -> freedist
LICENSE="GPL-2 public-domain freedist"
KEYWORDS="amd64 ppc sparc x86"
SLOT="0"
IUSE=""

RDEPEND="x11-wm/icewm"
DEPEND=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	find . -name \.xvpics | xargs rm -rf
	find . -name \*~ | xargs rm -rf
}

src_install() {
	local ICEWM_THEMES=/usr/share/icewm/themes
	dodir ${ICEWM_THEMES} || die
	cp -pR * "${D}"/${ICEWM_THEMES} || die
	chown -R root:0 "${D}"/${ICEWM_THEMES} || die
	#chmod -R o-w ${D}/${ICEWM_THEMES}
	rm -f "${D}"/${ICEWM_THEMES}/Crus-IceWM/cpframes.sh || die
	find "${D}"/${ICEWM_THEMES} -type d | xargs chmod 755 || die
	find "${D}"/${ICEWM_THEMES} -type f | xargs chmod 644 || die
}

pkg_postinst() {
	einfo "Themes created by: Sawsedge, david_bv, tal256, adisk, fagga and Josh Rush."
}
