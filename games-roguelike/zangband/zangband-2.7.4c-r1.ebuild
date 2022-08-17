# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
	acct-group/gamestat
	sys-libs/ncurses:=
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt
	tk? (
		dev-lang/tcl:=
		dev-lang/tk:=
	)
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="acct-group/gamestat"

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
		--datadir="${EPREFIX}"/var
		--with-setgid=gamestat
		--without-gtk
		$(use_with tk tcltk)
	)

	econf "${myconf[@]}"
}

src_install() {
	dodir /var/games/${PN}

	# Install the basic files but remove unneeded bits to install ourselves
	emake DESTDIR="${ED}"/var/games/${PN}/ installbase
	# Covered via DOCS
	rm "${ED}"/var/games/${PN}/{angdos.cfg,readme,z_faq.txt,z_update.txt} || die

	# Install everything else and fix the permissions
	dobin zangband

	keepdir /var/games/zangband/lib/{bone,info,user,save,xtra/{,help,music}}

	# All users in the games group need write permissions to
	# some important dirs
	fowners -R :gamestat /var/games/${PN}/lib/{apex,data,save,user}
	fperms -R g+w /var/games/${PN}/lib/{apex,data,save,user}

	einstalldocs
}
