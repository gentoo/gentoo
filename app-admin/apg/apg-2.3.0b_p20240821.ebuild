# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

GIT_COMMIT="dcddc65648f8b71ba8b9a9c1946034badb4ae7f3"

BASEVER=$(ver_cut 1-4)

DESCRIPTION="Another Password Generator"
HOMEPAGE="https://github.com/wilx/apg"
SRC_URI="https://github.com/wilx/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GIT_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="cracklib"

DEPEND="
	virtual/libcrypt:=
	cracklib? ( sys-libs/cracklib )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-crypt_password.patch"
	"${FILESDIR}/${PN}-2.3.0b_p20150129-cracklib.patch"
)

DOCS=( CHANGES README THANKS TODO doc/APG_TIPS doc/rfc0972.txt doc/rfc1750.txt )

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
