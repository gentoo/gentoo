# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
inherit multilib cmake python-single-r1 git-r3

DESCRIPTION="pahole (Poke-a-Hole) and other DWARF2 utilities"
HOMEPAGE="https://git.kernel.org/cgit/devel/pahole/pahole.git/"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/devel/pahole/pahole.git"

LICENSE="GPL-2" # only
SLOT="0"
KEYWORDS=""
IUSE="debug"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/elfutils-0.178
	sys-libs/zlib"
DEPEND="${RDEPEND}"

DOCS=( README README.ctracer NEWS )

PATCHES=(
	"${FILESDIR}"/${PN}-1.10-python-import.patch
)

src_prepare() {
	cmake_src_prepare
	python_fix_shebang ostra/ostra-cg ostra/python/ostra.py
}

src_configure() {
	local mycmakeargs=( "-D__LIB=$(get_libdir)" )
	cmake_src_configure
}

src_test() { :; }

src_install() {
	cmake_src_install
}
