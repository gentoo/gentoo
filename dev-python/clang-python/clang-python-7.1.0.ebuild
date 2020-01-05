# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )
inherit python-r1

MY_P=cfe-${PV/_/}.src
DESCRIPTION="Python bindings for sys-devel/clang"
HOMEPAGE="https://llvm.org/"
SRC_URI="https://releases.llvm.org/${PV/_//}/${MY_P}.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# The module is opening libclang.so directly, and doing some blasphemy
# on top of it.
RDEPEND="
	>=sys-devel/clang-${PV}:*
	!sys-devel/llvm:0[clang(-),python(-)]
	!sys-devel/clang:0[python(-)]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}/bindings/python

src_unpack() {
	einfo "Unpacking parts of ${MY_P}.tar.xz ..."
	tar -xJf "${DISTDIR}/${MY_P}.tar.xz" "${MY_P}/bindings/python" || die
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
