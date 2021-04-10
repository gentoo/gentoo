# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )

inherit autotools desktop lua-single

DATA_PV="1.0.0"
DESCRIPTION="Underwater puzzle game - find a safe way out"
HOMEPAGE="http://fillets.sourceforge.net/"
SRC_URI="mirror://sourceforge/fillets/fillets-ng-${PV}.tar.gz
	mirror://sourceforge/fillets/fillets-ng-data-${DATA_PV}.tar.gz"
S="${WORKDIR}/fillets-ng-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-libs/fribidi
	>=media-libs/libsdl-1.2[sound,video]
	>=media-libs/sdl-mixer-1.2.5[vorbis]
	>=media-libs/sdl-image-1.2.2[png]
	media-libs/sdl-ttf
	media-libs/smpeg
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.1-respect-AR.patch"
)

src_prepare() {
	default

	#.mod was renamed to .fmod in lua 5.1.3 - bug #223271
	sed -i \
		-e 's/\.mod(/.fmod(/' \
		$(grep -rl "\.mod\>" "${WORKDIR}"/fillets-ng-data-${DATA_PV}) \
		|| die "sed failed"

	rm -f missing || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf --datadir=/usr/share/${PN}
}

src_install() {
	rm -f COPYING || die

	default

	insinto /usr/share/${PN}
	cd "${WORKDIR}"/fillets-ng-data-${DATA_PV} || die

	doins -r *
	newicon images/icon.png ${PN}.png
	make_desktop_entry fillets "Fish Fillets NG"
}
