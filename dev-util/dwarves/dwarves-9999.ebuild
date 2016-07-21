# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://git.kernel.org/pub/scm/devel/pahole/pahole.git"

PYTHON_COMPAT=( python2_7 )
inherit multilib cmake-utils git-2 python-single-r1

DESCRIPTION="pahole (Poke-a-Hole) and other DWARF2 utilities"
HOMEPAGE="https://git.kernel.org/cgit/devel/pahole/pahole.git/"

LICENSE="GPL-2" # only
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND=">=dev-libs/elfutils-0.131
	sys-libs/zlib"
DEPEND="${RDEPEND}"

DOC=( README README.ctracer )

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
