# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Text User Interface that implements the well known CUA widgets"
HOMEPAGE="http://tvision.sourceforge.net/"
SRC_URI="mirror://sourceforge/tvision/rhtvision_${PV/_pre/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"
IUSE=""

DOCS=( readme.txt THANKS TODO )

HTML_DOCS=( www-site/. )

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}/${P}-gcc41.patch"
	"${FILESDIR}/${P}-outb.patch"
	"${FILESDIR}/${P}-underflow.patch"
	"${FILESDIR}/${P}-asneeded.patch"
	"${FILESDIR}/${P}-gcc44.patch"
	"${FILESDIR}/${P}-ldconfig.patch"
	"${FILESDIR}/${P}-flags.patch"
	"${FILESDIR}/${P}-gcc6.patch" # bug #594176
	"${FILESDIR}/${P}-build-system.patch" # for EAPI=6
)

src_prepare() {
	# Strip hunk from invalid characters for gcc6.patch
	sed -e ":TScrollChars: s:; // \x1E\x1F\xB1\xFE\xB2:;:" \
		-e ":TScrollChars: s:; // \x11\x10\xB1\xFE\xB2:;:" \
		-i classes/tvtext1.cc || die
	default
}

src_configure() {
	./configure --fhs || die
}

src_install() {
	emake DESTDIR="${D}" install \
		prefix="\${DESTDIR}/usr" \
		libdir="\$(prefix)/$(get_libdir)"

	einstalldocs
	dosym rhtvision /usr/include/tvision
}
