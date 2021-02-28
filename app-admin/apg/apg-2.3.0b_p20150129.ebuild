# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

BASEVER=$(ver_cut 1-4)

DESCRIPTION="Another Password Generator"
HOMEPAGE="https://github.com/wilx/apg"
SRC_URI="https://dev.gentoo.org/~bircoph/distfiles/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cracklib"

DEPEND="cracklib? ( sys-libs/cracklib )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-${BASEVER}-crypt_password.patch"
	"${FILESDIR}/${P}-cracklib.patch"
)

DOCS=( CHANGES README THANKS TODO doc/APG_TIPS doc/rfc0972.txt doc/rfc1750.txt )

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with cracklib)
}

src_install() {
	default
	doman doc/man/apg*
}
