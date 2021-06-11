# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="An enhanced version of the Roguelike game Angband"
HOMEPAGE="http://www.zangband.org/"
SRC_URI="ftp://ftp.sunet.se/pub/games/Angband/Variant/ZAngband/${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="Moria"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tk"

RDEPEND="
	tk? (
		dev-lang/tcl:0=
		dev-lang/tk:0=
		)
	x11-libs/libXaw"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

DOCS=( readme z_faq.txt z_update.txt )

PATCHES=(
	"${FILESDIR}"/${P}-tk85.patch
	"${FILESDIR}"/${P}-rng.patch
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-makefile.patch
)

src_prepare() {
	default

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	local myconf=(
		--libdir="${EPREFIX}"/$(get_libdir)/${PN}
		--with-setgid="nobody"
		--without-gtk
		$(use_with tk tcltk)
	)

	econf "${myconf[@]}"
}

src_install() {
	# Install the basic files but remove unneeded crap
	emake DESTDIR="${D}/usr/" installbase
	rm "${ED}"/usr/{angdos.cfg,readme,z_faq.txt,z_update.txt} || die

	# Install everything else and fix the permissions
	dobin zangband

	einstalldocs
}
