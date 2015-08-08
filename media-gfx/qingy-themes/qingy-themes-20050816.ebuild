# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Collection of qingy themes"

HOMEPAGE="http://themes.freshmeat.net/projects/qingy-lila/
	http://themes.freshmeat.net/projects/kitten/
	http://themes.freshmeat.net/projects/blnkftre/
	http://themes.freshmeat.net/projects/fireplace/
	http://themes.freshmeat.net/projects/_dragonfly_/
	http://themes.freshmeat.net/projects/computerroom/
	http://themes.freshmeat.net/projects/_biohazard_/
	http://themes.freshmeat.net/projects/_casablanca_/
	http://themes.freshmeat.net/projects/_matrix_/
	http://themes.freshmeat.net/projects/adc/
	http://themes.freshmeat.net/projects/rouge/
	http://themes.freshmeat.net/projects/_aquaish_/
	http://themes.freshmeat.net/projects/macmen/
	http://themes.freshmeat.net/projects/lambretta/
	http://themes.freshmeat.net/projects/_vendetta_/
	http://themes.freshmeat.net/projects/chaosr/
	http://themes.freshmeat.net/projects/fgdm/
	http://themes.freshmeat.net/projects/fkdm/"

THEME_URI="http://download.freshmeat.net/themes"

SRC_URI="http://jefklak.suidzer0.org/downloads/qingy/qingy_lila.tar.bz2
	${THEME_URI}/kitten/kitten-default-1.0.tar.gz
	${THEME_URI}/blnkftre/blnkftre-default.tar.gz
	${THEME_URI}/fireplace/fireplace-default.tar.gz
	${THEME_URI}/_dragonfly_/_dragonfly_-default.tar.gz
	${THEME_URI}/computerroom/computerroom-default.tar.gz
	${THEME_URI}/_biohazard_/_biohazard_-default-1.0.tar.gz
	${THEME_URI}/_casablanca_/_casablanca_-default-1.0.tar.gz
	${THEME_URI}/_matrix_/_matrix_-default-2.tar.gz
	${THEME_URI}/adc/adc-default.tar.gz
	${THEME_URI}/rouge/rouge-default.tar.gz
	${THEME_URI}/_aquaish_/_aquaish_-default.tar.gz
	${THEME_URI}/macmen/macmen-default.tar.gz
	${THEME_URI}/lambretta/lambretta-default.tar.gz
	${THEME_URI}/_vendetta_/_vendetta_-default.tar.gz
	${THEME_URI}/blnkftre/blnkftre-default.tar.gz
	${THEME_URI}/chaosr/chaosr-default.tar.gz
	${THEME_URI}/fgdm/fgdm-default.tar.gz
	${THEME_URI}/fkdm/fkdm-default.tar.gz"

# lila -> freedist
# all the others -> GPL
LICENSE="GPL-2 freedist"
KEYWORDS="amd64 ppc x86"

SLOT="0"
IUSE=""
RDEPEND="sys-apps/qingy"

S=${WORKDIR}

src_install()
{
	local QINGY_THEMES=/usr/share/qingy/themes
	dodir ${QINGY_THEMES}
	cp -dpR * ${D}/${QINGY_THEMES}
	chown -R root:0 ${D}/${QINGY_THEMES}
}
