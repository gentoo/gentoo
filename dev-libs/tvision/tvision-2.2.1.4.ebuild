# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Text User Interface that implements the well known CUA widgets"
HOMEPAGE="http://tvision.sourceforge.net/"
MY_PVR=${PVR:0:5}-${PVR:6}
SRC_URI="mirror://sourceforge/tvision/rhtvision_${MY_PVR}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+X debug gpm"

DOCS=( readme.txt THANKS TODO )
HTML_DOCS=( www-site/. )

S=${WORKDIR}/${PN}

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
		x11-libs/libxcb
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix-dot-INC.patch"
	"${FILESDIR}/${P}-ldconfig.patch"
	"${FILESDIR}/${P}-build-system.patch"
	"${FILESDIR}/${P}-gcc6.patch"
	"${FILESDIR}/${P}-flags.patch"
)

src_configure() {
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
	dosym rhtvision /usr/include/tvision

	# remove CVS directory which gets copied over
	rm -rf "${ED%/}/usr/share/doc/${P}/html/CVS" || die

	# TODO: remove locales which are not needed, depending on current user
	# locale settings. How?
}
