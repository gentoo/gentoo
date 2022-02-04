# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop optfeature

DESCRIPTION="Typing tutorial with lots of eye-candy"
HOMEPAGE="https://www.tux4kids.com/"
SRC_URI="https://github.com/tux4kids/${PN}/archive/upstream/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-upstream-${PV}"

LICENSE="CC-BY-3.0 CC-BY-SA-3.0 GPL-3+ public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	media-libs/libsdl[video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer
	media-libs/sdl-pango"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-games-group.patch
	"${FILESDIR}"/${P}-missing-text.patch
	"${FILESDIR}"/${P}-t4kcommon.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local econfargs=(
		# these are a placeholder for future features, i.e. not useful for now
		--without-rsvg
		--without-sdlnet
	)
	econf "${econfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install # skip einstalldocs, wrong files

	keepdir /etc/${PN} /var/lib/${PN}

	fowners :gamestat /var/lib/${PN} /usr/bin/${PN}
	fperms g+s /usr/bin/${PN}
	fperms 660 /var/lib/${PN}

	newicon icon.png ${PN}.png
	domenu ${PN}.desktop

	# bundled fonts are unused if sdl-pango is enabled
	rm -r "${ED}"/usr/share/${PN}/fonts || die
	rm "${ED}"/usr/share/doc/${PF}/{ABOUT-NLS,COPYING,OFL,INSTALL} || die
	rmdir "${ED}"/var/lib/${PN}/words || die
}

pkg_postinst() {
	# mod detection fails if using modplug over mikmod
	optfeature "music support" "media-libs/sdl-mixer[mod,mikmod,vorbis]"
}
