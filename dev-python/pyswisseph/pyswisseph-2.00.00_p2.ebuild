# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

PLEVEL=${PV##*_p}
MY_PV=${PV/_p*}
MY_PV=${MY_PV}-${PLEVEL}

DESCRIPTION="Python extension to the AstroDienst Swiss Ephemeris"
HOMEPAGE="https://github.com/astrorigin/pyswisseph"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/astrorigin/pyswisseph.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${MY_PV}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="GPL-2+"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
