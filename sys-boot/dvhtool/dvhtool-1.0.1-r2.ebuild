# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Tool to copy kernel(s) into the volume header on SGI MIPS-based workstations"
HOMEPAGE="http://packages.debian.org/unstable/utils/dvhtool"
SRC_URI="mirror://debian/pool/main/d/dvhtool/dvhtool_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"

IUSE=""
DEPEND=""
RDEPEND=""

S="${S}.orig"

PATCHES=(
	"${FILESDIR}/${P}-debian.diff"
	"${FILESDIR}/${P}-debian-warn_type_guess.diff"
	"${FILESDIR}/${P}-debian-xopen_source.diff"
	"${FILESDIR}/${P}-add-raid-lvm-parttypes.patch"
)

src_prepare() {
	default

	# Fix automake warning
	mv configure.{in,ac} || die

	eapply_user
	eautoreconf
}

src_configure() {
	CC="$(tc-getCC)" LD="$(tc-getLD)" \
		econf
}

src_compile() {
	CC="$(tc-getCC)" LD="$(tc-getLD)" \
		emake
}
