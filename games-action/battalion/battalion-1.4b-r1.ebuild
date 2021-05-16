# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Be a rampaging monster and destroy the city"
HOMEPAGE="http://evlweb.eecs.uic.edu/aej/AndyBattalion.html"
SRC_URI="http://evlweb.eecs.uic.edu/aej/BATTALION/${PN}${PV}.tar.bz2"
S="${WORKDIR}"/${PN}${PV}

LICENSE="battalion HPND"
SLOT="0"
KEYWORDS="~x86"

DEPEND="
	virtual/glu
	virtual/opengl
	x11-libs/libX11"
RDEPEND="${DEPEND}"

DEPEND+=" virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-warning.patch
	"${FILESDIR}"/${PN}-1.4b-fix-build-system.patch
)

src_prepare() {
	default

	# Modify data paths
	sed -i \
		-e "s:SOUNDS/:${EPREFIX}/usr/share/${PN}/SOUNDS/:" \
		-e "s:MUSIC/:${EPREFIX}/usr/share/${PN}/MUSIC/:" \
		audio.c || die
	sed -i \
		-e "s:DATA/:${EPREFIX}/usr/share/${PN}/DATA/:" \
		-e "s:/usr/tmp:${EPREFIX}/var/${PN}:" \
		battalion.c || die
	sed -i \
		-e "s:TEXTURES/:${EPREFIX}/usr/share/${PN}/TEXTURES/:" \
		graphics.c || die

	# Only .raw sound files are used on Linux. The .au files are not needed.
	rm {SOUNDS,MUSIC}/*.au || die
}

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	dobin battalion
	einstalldocs

	insinto /usr/share/${PN}
	doins -r DATA MUSIC SOUNDS TEXTURES

	dodir /var/${PN}
	touch "${ED%/}"/var/${PN}/battalion_hiscore || die
	fperms 660 /var/${PN}/battalion_hiscore
}

pkg_postinst() {
	elog "Sound and music are not enabled by default."
	elog "Use the S and M keys to enable them in-game, or start the game with"
	elog "the -s and -m switches: battalion -s -m"
}
