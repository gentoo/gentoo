# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

MY_PN=ClanLib

DESCRIPTION="Multi-platform game development library"
HOMEPAGE="https://github.com/sphair/ClanLib"
SRC_URI="https://github.com/sphair/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="4.0"
KEYWORDS="~amd64 ~x86" #not big endian safe #82779
IUSE="cpu_flags_x86_sse2 doc examples ipv6 opengl sound static-libs X"
REQUIRED_USE="opengl? ( X )"

RDEPEND="
	sys-libs/zlib
	X? (
		media-libs/freetype:2
		media-libs/fontconfig
		x11-libs/libX11
		opengl? (
			virtual/opengl
			x11-libs/libXrender
		)
	)
	sound? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-lang/perl
		media-gfx/graphviz
	)"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.0-fix-build-system.patch
	"${FILESDIR}"/${PN}-4.0.0-freetype_pkgconfig.patch #658424
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc docs)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable opengl clanGL)
		$(use_enable opengl clanUI)
		$(use_enable X clanDisplay)
		$(use_enable sound clanSound)
		$(use_enable ipv6 getaddr)
		$(use_enable static-libs static)
	)

	tc-export PKG_CONFIG

	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	use doc && emake html
}

src_install() {
	default

	use doc && emake DESTDIR="${D}" install-html
	use examples && dodoc -r Examples Resources

	# package provides .pc files
	find "${ED}" -name '*.la' -delete || die
}
