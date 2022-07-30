# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit llvm.org python-r1

DESCRIPTION="Python bindings for sys-devel/clang"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# The module is opening libclang.so directly, and doing some blasphemy
# on top of it.
DEPEND="
	>=sys-devel/clang-${PV}:*
	!sys-devel/llvm:0[clang(-),python(-)]
	!sys-devel/clang:0[python(-)]
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"
BDEPEND="
	${PYTHON_DEPS}
"

LLVM_COMPONENTS=( clang/bindings/python )
llvm.org_set_globals

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

src_test() {
	python_foreach_impl python_test
}

src_install() {
	python_foreach_impl python_domodule clang
}
