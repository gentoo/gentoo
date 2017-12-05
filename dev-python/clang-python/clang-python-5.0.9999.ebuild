# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit git-r3 python-r1

DESCRIPTION="Python bindings for sys-devel/clang"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://git.llvm.org/git/clang.git
	https://github.com/llvm-mirror/clang.git"
EGIT_BRANCH="release_50"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# The module is opening libclang.so directly, and doing some blasphemy
# on top of it.
RDEPEND="
	>=sys-devel/clang-${PV}:*
	!sys-devel/llvm:0[clang(-),python(-)]
	!sys-devel/clang:0[python(-)]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${P}/bindings/python

src_unpack() {
	git-r3_fetch
	git-r3_checkout '' '' '' bindings/python
}

src_test() {
	python_foreach_impl nosetests -v || die
}

src_install() {
	python_foreach_impl python_domodule clang
}
