# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="C64 SID player library"
HOMEPAGE="http://critical.ch/distfiles/"
SRC_URI="http://critical.ch/distfiles/${P}.tgz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ppc ppc64 ~riscv sparc x86"

DOCS=( AUTHORS DEVELOPER )
PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
)

src_prepare() {
	default

	# Ships with a autoconf-2.59 generated ./configure, which misdetects strnicmp, bug #859919
	mv configure.{in,ac} || die
	eautoreconf
}

multilib_src_configure() {
	# Uses register storage class specifier and it is an ancient version that may have
	# other problems with newer C++, bug #896252
	append-cxxflags -std=gnu++14
	ECONF_SOURCE="${S}" econf
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
