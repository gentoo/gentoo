# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RPM_COMPRESS_TYPE=none
inherit autotools rpm

DESCRIPTION="The xsri wallpaper setter from RedHat"
HOMEPAGE="https://fedoraproject.org"
SRC_URI="
	https://download.fedoraproject.org/pub/fedora/linux/releases/$(ver_cut 7)/Everything/source/SRPMS/${P/_p*/}-$(ver_cut 5).fc$(ver_cut 7).src.rpm
"
S=${WORKDIR}/${P/_p*/}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-libs/popt
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P/_p*/}-configure.patch
)

DOCS=( AUTHORS ChangeLog README )

src_unpack() {
	rpm_unpack
	unpack "${WORKDIR}"/${P/_p*/}.tar.gz
}

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default
	doman ../${PN}.1
}
