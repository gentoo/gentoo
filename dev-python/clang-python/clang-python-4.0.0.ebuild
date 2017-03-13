# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-r1

DESCRIPTION="Python bindings for sys-devel/clang"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://releases.llvm.org/${PV/_//}/cfe-${PV/_/}.src.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

# The module is opening libclang.so directly, and doing some blasphemy
# on top of it.
RDEPEND="
	>=sys-devel/clang-${PV}:*
	!sys-devel/llvm:0[clang(-),python(-)]
	!sys-devel/clang:0[python(-)]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S=${WORKDIR}/cfe-${PV/_/}.src/bindings/python

src_test() {
	python_foreach_impl nosetests -v
}

src_install() {
	python_foreach_impl python_domodule clang
}
