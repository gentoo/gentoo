# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools eutils rpm

DESCRIPTION="The xsri wallpaper setter from RedHat"
HOMEPAGE="https://fedoraproject.org"
SRC_URI="
	https://download.fedoraproject.org/pub/fedora/linux/releases/$(ver_cut 7)/Everything/source/SRPMS/${P/_p*/}-$(ver_cut 5).fc$(ver_cut 7).src.rpm
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${P/_p*/}-configure.patch
)
S=${WORKDIR}/${P/_p*/}
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
