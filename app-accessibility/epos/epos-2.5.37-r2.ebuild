# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="language independent text-to-speech system"
HOMEPAGE="http://epos.ufe.cz/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 x86"
IUSE=""

DEPEND=">=app-text/sgmltools-lite-3.0.3-r9
	dev-util/byacc"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.37-gcc43.patch
	"${FILESDIR}"/${PN}-2.5.37-gcc45.patch
	"${FILESDIR}"/${PN}-2.5.37-gcc47.patch
	"${FILESDIR}"/${PN}-2.5.37-disable-tests.patch
	"${FILESDIR}"/${PN}-2.5.37-gcc7.patch
)

src_prepare() {
	default
	sed -i -e "s/CCC/#CCC/" configure.ac || die

	eautoreconf
}

src_configure() {
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
