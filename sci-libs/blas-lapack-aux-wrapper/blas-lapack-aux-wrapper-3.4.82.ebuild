# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="BLAS/LAPACK wrappers for FlexiBLAS"
HOMEPAGE="https://gitweb.gentoo.org/proj/blas-lapack-aux-wrapper.git/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="index64"

RDEPEND="
	>=sci-libs/flexiblas-${PV}[index64?]
	!<sci-libs/flexiblas-3.4.82-r2[system-blas(-)]
"

# we do not call the compiler, only the linker
QA_FLAGS_IGNORED=".*"

src_configure() {
	local emesonargs=(
		-Dilp64=$(usex index64 true false)
	)

	meson_src_configure
}
