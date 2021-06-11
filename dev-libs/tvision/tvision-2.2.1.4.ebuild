# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV=$(ver_rs 3 -)
DESCRIPTION="Text User Interface that implements the well known CUA widgets"
HOMEPAGE="http://tvision.sourceforge.net/"
SRC_URI="mirror://sourceforge/tvision/rhtvision_${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+X debug gpm"

DOCS=( readme.txt THANKS TODO )
HTML_DOCS=( www-site/. )

# installed lib links to those
RDEPEND="
	dev-libs/libbsd
	sys-apps/util-linux
	sys-libs/ncurses:0=
	gpm? ( sys-libs/gpm )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXmu
		x11-libs/libXt
		x11-libs/libxcb:=
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix-dot-INC.patch"
	"${FILESDIR}/${P}-ldconfig.patch"
	"${FILESDIR}/${P}-build-system.patch"
	"${FILESDIR}/${P}-gcc6.patch"
	"${FILESDIR}/${P}-flags.patch"
	"${FILESDIR}/${P}-fix-overloaded-abs.patch"
	"${FILESDIR}/${P}-Gentoo-specific-fix-linker-paths.patch"
)

src_configure() {
	tc-export CC CXX

	# Note: Do not use econf here, this isn't an autoconf configure script,
	# but a perl based script which simply calls config.pl
	./configure --fhs \
		$(use_with debug debug) \
		--without-static \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install \
		prefix="\${DESTDIR}/${EPREFIX}/usr" \
		libdir="\$(prefix)/$(get_libdir)"

	einstalldocs

	# remove CVS directory which gets copied over
	rm -r "${ED}/usr/share/doc/${P}/html/CVS" || die
}
