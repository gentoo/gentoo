# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Open source build system"
HOMEPAGE="http://mesonbuild.com/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	>=dev-util/ninja-1.6.0
"
RDEPEND="${DEPEND}"

DOCS=( authors.txt contributing.txt )

PATCHES=(
	# https://github.com/mesonbuild/meson/pull/663
	"${FILESDIR}"/${P}-runpath.patch
)

src_install() {
	distutils-r1_src_install
	for i in mesonconf mesonintrospect meson wraptool; do
		dosym "${i}.py" "/usr/bin/${i}"
	done
}
