# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A little bit like the famous OS X dock but in shape of a pie menu"
HOMEPAGE="
	http://markusfisch.de/PieDock
	https://github.com/markusfisch/PieDock
"
SRC_URI="
	https://github.com/markusfisch/PieDock/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND="
	media-libs/libpng:0=
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXrender
	gtk? (
		dev-libs/atk
		dev-libs/glib
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
	)
"
DEPEND="${RDEPEND}"
DOCS=( res/${PN}rc.sample AUTHORS ChangeLog NEWS )
PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-signals.patch
)
S=${WORKDIR}/PieDock-${PV}

src_configure() {
	econf \
		$(use_enable gtk) \
		--disable-kde \
		--bindir="${EPREFIX}"/usr/bin \
		--enable-xft \
		--enable-xmu \
		--enable-xrender
}
