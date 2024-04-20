# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop xdg

MY_P="KoboDeluxe-${PV/_/}"
DESCRIPTION="An SDL port of xkobo, a addictive space shoot-em-up"
HOMEPAGE="http://www.olofson.net/kobodl/"
SRC_URI="http://www.olofson.net/kobodl/download/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="opengl"

DEPEND="media-libs/libsdl[joystick]
	media-libs/sdl-image[png]
	opengl? ( virtual/opengl )
"
RDEPEND="${DEPEND}
	acct-group/gamestat
"

PATCHES=(
	"${FILESDIR}"/${P}-glibc29.patch
	"${FILESDIR}"/${P}-glibc2.10.patch
	"${FILESDIR}"/${P}-clang.patch
	"${FILESDIR}"/${P}-midi-crash-fix.patch
)

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	unpack ./icons.tar.gz
}

src_prepare() {
	default

	# Fix paths
	sed -i \
		-e 's:\$(datadir)/kobo-deluxe:$(datadir)/kobodeluxe:' \
		-e "s:\$(sharedstatedir)/kobo-deluxe/scores:${EPREFIX}/var/games/kobodeluxe:" \
		configure || die "sed configure failed"

	sed -i \
		-e 's:kobo-deluxe:kobodeluxe:' \
		data/gfx/Makefile.in \
		data/sfx/Makefile.in || die "sed data/Makefile.in failed"
}

src_configure() {
	econf $(use_enable opengl)
}

src_install() {
	default

	for size in 16 22 32 48 64 128; do
		newicon -s "${size}" icons/KDE/icons/${size}x${size}/kobodl.png KoboDeluxe.png
	done
	make_desktop_entry kobodl "Kobo Deluxe" KoboDeluxe

	keepdir /var/games/kobodeluxe
	fowners -R :gamestat /var/games/kobodeluxe/ /usr/bin/kobodl
	fperms g+s /usr/bin/kobodl
	fperms -R g+w /var/games/kobodeluxe
}
