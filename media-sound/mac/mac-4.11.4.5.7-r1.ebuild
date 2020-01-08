# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

MY_PN=monkeys-audio
MY_PV=$(ver_cut 1-2)-u$(ver_cut 3)-b$(ver_cut 4)-s$(ver_cut 5)
MY_P=${MY_PN}_${MY_PV}

DESCRIPTION="Monkey's Audio Codecs"
HOMEPAGE="http://www.deb-multimedia.org/dists/testing/main/binary-amd64/package/monkeys-audio.php"
SRC_URI="http://www.deb-multimedia.org/pool/main/m/monkeys-audio/${MY_P}.orig.tar.gz"

LICENSE="mac"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="cpu_flags_x86_mmx static-libs"

RDEPEND=""
DEPEND="
	sys-apps/sed
	cpu_flags_x86_mmx? ( dev-lang/yasm )
"

S=${WORKDIR}/${MY_P/_/-}

PATCHES=(
	"${FILESDIR}"/${P}-output.patch
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-null.patch
)

DOCS=( AUTHORS ChangeLog NEWS TODO README src/History.txt src/Credits.txt ChangeLog.shntool )

RESTRICT="mirror"

src_prepare() {
	default

	sed -i -e 's:-O3::' configure || die
}

src_configure() {
	append-cppflags -DSHNTOOL
	use cpu_flags_x86_mmx && append-ldflags -Wl,-z,noexecstack

	econf \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_mmx assembly)
}

src_install() {
	default

	insinto /usr/include/${PN}
	doins src/MACLib/{BitArray,UnBitArrayBase,Prepare}.h #409435

	find "${D}" -name '*.la' -delete || die
}
