# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Collection of IceWM themes"
HOMEPAGE="http://www.icewm.org/
	http://themes.freshmeat.net/projects/icecrack/
	http://themes.freshmeat.net/projects/icebox/
	http://themes.freshmeat.net/projects/cyrusicewm/
	http://themes.freshmeat.net/projects/greyscaled/
	http://themes.freshmeat.net/projects/ufosightings/
	http://themes.freshmeat.net/projects/1in1-xp/
	http://themes.freshmeat.net/projects/winclassic/
	http://themes.freshmeat.net/projects/elberg-icewm/
	http://themes.freshmeat.net/projects/gertplastik/
	http://themes.freshmeat.net/projects/qnx_icewm/
	http://themes.freshmeat.net/projects/truecurve/
	http://themes.freshmeat.net/projects/miggy4/
	http://themes.freshmeat.net/projects/axxlite/
	http://themes.freshmeat.net/projects/phaaba/
	http://themes.freshmeat.net/projects/icequa/
	http://themes.freshmeat.net/projects/bluecrux/
	http://themes.freshmeat.net/projects/cruxteal/
	http://themes.freshmeat.net/projects/kliin/
	http://themes.freshmeat.net/projects/icewmsilverxp/"
THEME_URI="http://download.freshmeat.net/themes"
SRC_URI="${THEME_URI}/icecrack/icecrack-default-2.0.0.tar.gz
	${THEME_URI}/icebox-red/icebox-red-default-1.2.13.tar.gz
	${THEME_URI}/cyrusicewm/cyrusicewm-1.0.0.tar
	${THEME_URI}/greyscaled/greyscaled-stable.tar.gz
	${THEME_URI}/ufosightings/ufosightings-1.0.0.tar.gz
	${THEME_URI}/1in1-xp/1in1-xp-default-1.1.tar
	http://themes.freshmeat.net/redir/winclassic/59702/url_tgz/theme-winclassic-1.1.tar.gz
	${THEME_URI}/elberg-icewm/elberg-icewm-default-1.1.tar.gz
	${THEME_URI}/gertplastik/gertplastik-default-20051225.tar
	${THEME_URI}/qnx_icewm/qnx_icewm-default-1.0.tar
	${THEME_URI}/truecurve/truecurve-default-1.0.4.tar
	${THEME_URI}/miggy4/miggy4-default-0.2.tar
	${THEME_URI}/axxlite/axxlite-default-1.0.tar
	${THEME_URI}/phaaba/phaaba-1.0.7.tar
	${THEME_URI}/icequa/icequa-default-1.0.2.tar
	http://themes.freshmeat.net/redir/bluecrux/30224/url_tgz/bluecrux-default-1.1.tar.gz
	http://themes.freshmeat.net/redir/cruxteal/34933/url_tgz/cruxteal-default-1.0.3.tar.gz
	http://themes.freshmeat.net/redir/kliin/32422/url_tgz/kliin-default-0.1.tar.gz
	mirror://sourceforge/icewmsilverxp/SilverXP-1.2.17-single-1.tar.bz2"

## GPL-2:
# icecrack, icebox, cyrus-icewm, ufosightings, axxlite, phaaba,
# winclassic, elberg, gertplastic, cruxteal, truecurve, bluecrux,
# silverxp
## Public Domain:
# greyscaled
## Freedist:
# 1in1-xp
## Free for non commercial use:
# qnx_icewm, kliin, miigy4
## BSD:
# icequa
LICENSE="GPL-2 public-domain freedist free-noncomm BSD"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
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
	rm -f "${D}"/${ICEWM_THEMES}/Cyrus-IceWM/cpframes.sh || die "Failed in Cyrus-IceWM theme fix"

	# start elberg theme packaging fix
	mv "${D}"/${ICEWM_THEMES}/themes/* "${D}"/${ICEWM_THEMES} || die "Error in elberg theme fix"
	rmdir "${D}"/${ICEWM_THEMES}/themes || die "Error in elberg theme fix"
	# end elberg theme packaging fix

	# start silverxp theme packaging fix
	mv "${D}"/${ICEWM_THEMES}/icewm/themes/* "${D}"/${ICEWM_THEMES} || die "Error in sivlerxp theme fix"
	rm -rf "${D}"/${ICEWM_THEMES}/icewm || die "Error in silverxp theme fix"
	# end silverxp theme packaging fix

	# use -print0 and xargs --null to handle file names with spaces!
	find "${D}"/${ICEWM_THEMES} -type d -print0 | xargs --null chmod 755 || die "Error changing permissions on theme dirs!"
	find "${D}"/${ICEWM_THEMES} -type f -print0 | xargs --null chmod 644 || die "Error changing permissions on theme files!"
}

pkg_postinst() {
	einfo "Themes created by: Sawsedge, david_bv, tal256, adisk, fagga, Josh
	Rush, Gert Brinkmann, Kocil, speleo3, bazhen, Alethes, Guy CLO, shellbeach,
	luciash d' being, Alexander Portnoy, drewbian, victord, ormaxx, and Michael
	Szota."
}
