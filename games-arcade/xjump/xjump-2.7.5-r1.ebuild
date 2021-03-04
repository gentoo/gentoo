# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DEBIAN_PATCH="6.1"
DESCRIPTION="An X game where one tries to jump up as many levels as possible"
HOMEPAGE="http://packages.debian.org/stable/games/xjump"
SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/x/${PN}/${PN}_${PV}-${DEBIAN_PATCH}.debian.tar.gz"
S="${WORKDIR}/${P}.orig"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXpm
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	# Where we will keep the highscore file:
	HISCORE_FILENAME=xjump.hiscores
	HISCORE_FILE="/var/lib/${PN}/${HISCORE_FILENAME}"

	eapply "${WORKDIR}"/debian/patches/0*.patch

	default

	# set up where we will keep the highscores file:
	sed -i \
		-e "/^CC/d" \
		-e "/^CFLAGS/d" \
		-e "s,/var/games/${PN},/var/lib/${PN}," \
		-e "s,/record,/${HISCORE_FILENAME}," \
		Makefile || die
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin xjump
	dodoc README.euc

	# Set up the hiscores file:
	dodir /var/lib/${PN}
	touch "${ED}/${HISCORE_FILE}" || die
	fperms 660 "${HISCORE_FILE}"
}
