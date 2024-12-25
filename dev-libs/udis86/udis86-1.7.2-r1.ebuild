# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"

inherit autotools multilib-minimal python-any-r1

DESCRIPTION="Disassembler library for the x86/-64 architecture sets"
HOMEPAGE="https://udis86.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa ppc ~ppc64 ~riscv ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	test? (
		amd64? ( dev-lang/yasm )
		arm64? ( dev-lang/yasm )
		x86? ( dev-lang/yasm )
	)"

PATCHES=(
	"${FILESDIR}"/${P}-docdir.patch
	"${FILESDIR}"/${P}-python3.patch
	"${FILESDIR}"/${P}-uninitialized-variable.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		--enable-shared \
		--with-pic \
		--with-python="${PYTHON}"
}

multilib_src_install_all() {
	einstalldocs

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
