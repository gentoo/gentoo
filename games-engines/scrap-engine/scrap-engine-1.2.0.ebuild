# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MY_PN="${PN//-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Terminal-based Python game engine involving objects on a map"
HOMEPAGE="https://github.com/lxgr-linux/scrap_engine"
SRC_URI="https://github.com/lxgr-linux/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-tests.patch
)

DOCS=(
	README.md
	docs/DOCS.md
	pics/example1.jpg
)

src_prepare() {
	default

	# PEP 517 needs this metadata.
	echo "Version: ${PV}" > "${S}"/PKG-INFO || die

	# Adjust doc resource paths.
	sed -i "s:\.\./pics/::g" docs/DOCS.md || die
}

python_test() {
	for TEST in "${S}"/tests/*.py; do
		"${EPYTHON}" "${TEST}" || die
	done
}
