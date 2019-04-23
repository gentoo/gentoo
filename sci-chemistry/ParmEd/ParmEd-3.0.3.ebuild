# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

if [[ $PV = *9999* ]]; then
	scm_eclass=git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	scm_eclass=vcs-snapshot
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils distutils-r1 ${scm_eclass}

DESCRIPTION="Parameter/topology editor and molecular simulator"
HOMEPAGE="https://parmed.github.io/ParmEd/html/index.html"

LICENSE="LGPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"

RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e "/delfile/d" \
		-e "/deldir/d" \
		-i setup.py || die
	distutils-r1_src_prepare
}
