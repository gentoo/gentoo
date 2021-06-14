# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN="rh${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Text User Interface that implements the well known CUA widgets"
HOMEPAGE="http://tvision.sourceforge.net/"
SRC_URI="https://github.com/set-soft/${PN}/releases/download/v${PV}/${MY_P}.src.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples nls"

DOCS=( readme.txt THANKS TODO )
HTML_DOCS=( www-site/. )

RDEPEND="
	dev-libs/libbsd
	media-libs/allegro:0[X]
	sys-apps/util-linux
	sys-libs/gpm
	sys-libs/ncurses:0=
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libxcb:=
"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1.4-flags.patch
	"${FILESDIR}"/${PN}-2.2.1.4-ldconfig.patch
	"${FILESDIR}"/${P}-0001-use-proper-AR.patch
)

src_configure() {
	tc-export CC CXX AR

	local myconf=()
	myconf+=(
		--fhs
		--prefix="${EPREFIX}/usr"
		--with-pthread
		--without-static
		--x-include="${EPREFIX}/usr/include/X11"
	)

	use nls || myconf+=( --no-intl )

	# Note: Do not use econf here, this isn't an autoconf configure script,
	# but a perl based script which simply calls config.pl
	einfo "Running ./configure ${myconf[@]}"
	./configure ${myconf[@]} || die
}

src_install() {
	emake DESTDIR="${D}" install \
		prefix="\${DESTDIR}${EPREFIX}/usr" \
		libdir="\$(prefix)/$(get_libdir)"

	einstalldocs

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc -r examples/*
	fi
}
