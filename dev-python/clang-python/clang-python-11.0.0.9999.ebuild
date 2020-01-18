# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit llvm.org python-r1

DESCRIPTION="Python bindings for sys-devel/clang"
HOMEPAGE="https://llvm.org/"
LLVM_COMPONENTS=( clang/bindings/python )
llvm.org_set_globals

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

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

src_test() {
	python_foreach_impl python_test
}

src_install() {
	python_foreach_impl python_domodule clang
}
