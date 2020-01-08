# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Python extension to the AstroDienst Swiss Ephemeris"
HOMEPAGE="https://github.com/astrorigin/pyswisseph"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/astrorigin/${PN}.git"
else
	COMMIT_ID=4f76befee7e39dff96b4c068cc6ce5fa66fb021c
	SRC_URI="https://github.com/astrorigin/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${COMMIT_ID}"
fi

LICENSE="GPL-2+"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
