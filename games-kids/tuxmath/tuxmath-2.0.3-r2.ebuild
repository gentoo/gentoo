# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop optfeature

DESCRIPTION="Educational arcade game where you have to solve maths problems"
HOMEPAGE="https://www.tux4kids.com/"
SRC_URI="mirror://debian/pool/main/t/${PN}/${PN}_${PV}.orig.tar.gz"
S="${WORKDIR}/${PN}_w_fonts-${PV}"

LICENSE="CC-BY-SA-3.0 CC-PD GPL-3+ public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls svg"

RDEPEND="
	>=dev-games/t4k-common-0.1.1-r1[svg?]
	dev-libs/libxml2:2
	media-libs/libsdl[video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer
	media-libs/sdl-net
	nls? ( virtual/libintl )"
DEPEND="
	${RDEPEND}
	svg? (
		gnome-base/librsvg:2
		x11-libs/cairo
	)"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-blits-to-tmblits.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	local econfargs=(
		$(use_enable nls)
		$(usex svg '' --without-rsvg)
	)
	econf "${econfargs[@]}"
}

src_install() {
	default

	doicon data/images/icons/${PN}.svg
	domenu ${PN}.desktop

	# bundled fonts are unused if t4k-common uses pango
	rm -r "${ED}"/usr/share/${PN}/fonts || die
	rm "${ED}"/usr/share/doc/${PF}/{COPYING_GPL3,GPL_VERSIONS,INSTALL,OFL,README_DATA_LICENSES} || die
}

pkg_postinst() {
	optfeature "music support" "media-libs/sdl-mixer[mod,vorbis]"
}
