# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Language independent text-to-speech system"
HOMEPAGE="http://epos.ufe.cz/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ppc ppc64 x86"
RESTRICT="test" # needs running eposd

BDEPEND="dev-util/byacc"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.37-gcc43.patch
	"${FILESDIR}"/${PN}-2.5.37-gcc45.patch
	"${FILESDIR}"/${PN}-2.5.37-gcc47.patch
	"${FILESDIR}"/${PN}-2.5.37-disable-tests.patch
	"${FILESDIR}"/${PN}-2.5.37-gcc7.patch
	"${FILESDIR}"/${PN}-2.5.37-gcc-11.patch
)

src_prepare() {
	default
	sed -i -e "s/CCC/#CCC/" configure.ac || die

	eautoreconf
}

src_configure() {
	# bug #649858
	append-flags -fno-delete-null-pointer-checks

	# Uses removed 'register' keyword, bug #894178
	append-cxxflags -std=c++03

	econf \
		--enable-charsets \
		--disable-portaudio \
		YACC=byacc
}

src_install() {
	default

	doinitd "${FILESDIR}/eposd"
	dodoc WELCOME THANKS Changes "${FILESDIR}/README.gentoo"
}
