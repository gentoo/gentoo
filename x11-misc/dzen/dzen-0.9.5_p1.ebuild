# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

COMMITID="488ab66019f475e35e067646621827c18a879ba1"

DESCRIPTION="A general purpose messaging, notification and menuing program for X11"
HOMEPAGE="https://github.com/robm/dzen"
SRC_URI="${HOMEPAGE}/tarball/${COMMITID} -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="minimal xft xinerama xpm"
SLOT="2"

RDEPEND="
	x11-libs/libX11
	xft? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )
	xpm? ( x11-libs/libXpm )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-unused-but-set.patch
)
DOCS=( README )
S=${WORKDIR}/robm-${PN}-${COMMITID:0:7}

src_configure() {
	tc-export CC PKG_CONFIG

	if use xinerama ; then
		sed -e '/^LIBS/s|$| -lXinerama|' \
			-e '/^CFLAGS/s|$| -DDZEN_XINERAMA|' \
			-i config.mk || die
	fi
	if use xpm ; then
		sed -e '/^LIBS/s|$| -lXpm|' \
			-e '/^CFLAGS/s|$| -DDZEN_XPM|' \
			-i config.mk || die
	fi
	if use xft ; then
		sed -e '/^LIBS/s|$| $(shell ${PKG_CONFIG} --libs xft)|' \
			-e '/^CFLAGS/s|$| -DDZEN_XFT $(shell ${PKG_CONFIG} --cflags xft)|' \
			-i config.mk || die
	fi
}

src_compile() {
	default
	use minimal || emake -C gadgets
}

src_install() {
	default

	if ! use minimal ; then
		emake -C gadgets DESTDIR="${D}" install
		dobin gadgets/*.sh
		dodoc gadgets/README*
	fi
}
