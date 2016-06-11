# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit multilib cmake-utils python-single-r1

DESCRIPTION="pahole (Poke-a-Hole) and other DWARF2 utilities"
HOMEPAGE="https://git.kernel.org/cgit/devel/pahole/pahole.git/"

LICENSE="GPL-2" # only
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/elfutils-0.131
	sys-libs/zlib"
DEPEND="${RDEPEND}"

if [[ ${PV//_p} == ${PV} ]]; then
	SRC_URI="http://fedorapeople.org/~acme/dwarves/${P}.tar.bz2"
	S=${WORKDIR}
else
	SRC_URI="https://dev.gentoo.org/~zzam/${PN}/${P}.tar.xz"
fi

DOCS=( README README.ctracer NEWS )
PATCHES=( "${FILESDIR}"/${PN}-1.10-python-import.patch )

src_configure() {
	local mycmakeargs=( "-D__LIB=$(get_libdir)" )
	cmake-utils_src_configure
}

src_test() { :; }

src_install() {
	cmake-utils_src_install
	python_fix_shebang "${D}"/usr/bin/ostra-cg \
		"${D}"/usr/share/dwarves/runtime/python/ostra.py
}
