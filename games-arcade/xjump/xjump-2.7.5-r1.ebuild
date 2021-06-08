# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DEBIAN_PATCH="6.1"
DESCRIPTION="An X game where one tries to jump up as many levels as possible"
HOMEPAGE="http://packages.debian.org/stable/games/xjump"
SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/x/${PN}/${PN}_${PV}-${DEBIAN_PATCH}.debian.tar.gz"
S="${WORKDIR}"/${P}.orig

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXpm
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

RDEPEND+=" acct-group/gamestat"

PATCHES=(
	"${WORKDIR}"/debian/patches/01_overflow.patch
	"${WORKDIR}"/debian/patches/02_fix_repeat.patch
	"${WORKDIR}"/debian/patches/03_source_warnings.patch
	"${WORKDIR}"/debian/patches/04_makefile_respect_cflags.patch
	"${WORKDIR}"/debian/patches/05_unneded_deps.patch
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default

	# set up where we will keep the highscores file:
	sed -i \
		-e "/^CC/d" \
		-e "/^CFLAGS/d" \
		-e "s,/record,/xjump.hiscores," \
		Makefile || die
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin xjump
	dodoc README.euc

	# Set up the hiscores file
	dodir /var/games/${PN}
	touch "${ED}"/var/games/${PN}/xjump.hiscores || die

	fperms -R 660 /var/games/${PN}
	fowners -R root:gamestat /var/games/${PN}
	fperms g+s /usr/bin/xjump
}
