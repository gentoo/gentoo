# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop flag-o-matic

DESCRIPTION="SDL/OpenGL space shoot'em up game"
HOMEPAGE="http://criticalmass.sourceforge.net/"
SRC_URI="mirror://sourceforge/criticalmass/CriticalMass-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/sdl-mixer
	media-libs/sdl-image[png]
	media-libs/libpng:0=
	virtual/opengl
	net-misc/curl
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/CriticalMass-${PV}"

src_prepare() {
	default

	eapply "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-system_curl.patch \
		"${FILESDIR}"/${P}-libpng14.patch \
		"${FILESDIR}"/${P}-cflags.patch \
		"${FILESDIR}"/${P}-libpng15.patch

	rm -rf curl

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	append-cxxflags -std=gnu++98 # Bug 612758
	default
}

src_install() {
	HTML_DOCS="Readme.html"
	default
	rm -f "${ED}/usr/bin/Packer"
	newicon critter.png ${PN}.png
	make_desktop_entry critter "Critical Mass"
}

pkg_postinst() {
	if ! has_version "media-libs/sdl-mixer[mod]" ; then
		ewarn
		ewarn "To hear music, you will have to rebuild media-libs/sdl-mixer"
		ewarn "with the \"mod\" USE flag turned on."
		ewarn
	fi
}
