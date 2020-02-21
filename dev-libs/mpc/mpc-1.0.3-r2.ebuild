# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils libtool ltprune multilib-minimal

DESCRIPTION="A library for multiprecision complex arithmetic with exact rounding"
HOMEPAGE="http://mpc.multiprecision.org/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

DEPEND=">=dev-libs/gmp-4.3.2:0=[${MULTILIB_USEDEP},static-libs?]
	>=dev-libs/mpfr-2.4.2:0=[${MULTILIB_USEDEP},static-libs?]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-mpfr-4.0.0.patch
	"${FILESDIR}"/${P}-no-ulp.patch
)

src_prepare() {
	default

	elibtoolize #347317
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
