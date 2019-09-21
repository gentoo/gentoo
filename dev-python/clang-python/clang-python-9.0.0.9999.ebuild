# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
inherit git-r3 python-r1

DESCRIPTION="Python bindings for sys-devel/clang"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
S=${WORKDIR}/${P}/bindings/python

EGIT_REPO_URI="https://git.llvm.org/git/clang.git
	https://github.com/llvm-mirror/clang.git"
EGIT_BRANCH="release_90"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

# The module is opening libclang.so directly, and doing some blasphemy
# on top of it.
RDEPEND="
	>=sys-devel/clang-${PV}:*
	!sys-devel/llvm:0[clang(-),python(-)]
	!sys-devel/clang:0[python(-)]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

src_unpack() {
	git-r3_fetch
	git-r3_checkout '' '' '' bindings/python
}

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

src_test() {
	python_foreach_impl python_test
}

src_install() {
	python_foreach_impl python_domodule clang
}
