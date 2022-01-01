# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs

DESCRIPTION="http protocol ping-like program"
HOMEPAGE="http://www.vanheusden.com/httping/"
SRC_URI="http://www.vanheusden.com/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa ~mips ~ppc ppc64 ~sparc x86"
IUSE="debug fftw libressl l10n_nl ncurses ssl +tfo"

RDEPEND="
	fftw? ( sci-libs/fftw:3.0 )
	ncurses? ( sys-libs/ncurses:0= )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
DEPEND="
	${RDEPEND}
	ncurses? ( virtual/pkgconfig )
"

# This would bring in test? ( dev-util/cppcheck ) but unlike
# upstream we should only care about compile/run time testing
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-flags.patch
)

src_prepare() {
	default

	# doman does not get PN-LANG.CAT so we move things around and then point at
	# it later
	if use l10n_nl; then
		mkdir nl || die
		mv httping-nl.1 nl/httping.1 || die
	fi
}

src_configure() {
	# not an autotools script
	echo > makefile.inc || die

	use ncurses && LDFLAGS+=" $( $( tc-getPKG_CONFIG ) --libs ncurses )"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		FW=$(usex fftw) \
		DEBUG=$(usex debug) \
		NC=$(usex ncurses) \
		SSL=$(usex ssl) \
		TFO=$(usex tfo)
}

src_install() {
	dobin httping
	doman httping.1

	use l10n_nl && doman -i18n=nl nl/httping.1
}
