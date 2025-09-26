# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit meson python-any-r1

DESCRIPTION="BLAS/LAPACK wrappers for FlexiBLAS"
HOMEPAGE="https://gitweb.gentoo.org/proj/blas-lapack-aux-wrapper.git/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="index64"

RDEPEND="
	!sci-libs/lapack[-flexiblas(-)]
	sci-libs/flexiblas:=[index64(-)?]
"
DEPEND="
	${RDEPEND}
	sci-libs/lapack:=[flexiblas(-),index64?,lapacke]
"
BDEPEND="
	${PYTHON_DEPS}
"

# we do not call the compiler, only the linker
QA_FLAGS_IGNORED=".*"

src_configure() {
	local emesonargs=(
		-Dilp64=$(usex index64 true false)
	)

	meson_src_configure
}
