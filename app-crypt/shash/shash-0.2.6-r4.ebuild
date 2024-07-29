# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1

DESCRIPTION="Generate or check digests or MACs of files"
HOMEPAGE="http://mcrypt.hellug.gr/shash/"
SRC_URI="ftp://mcrypt.hellug.gr/pub/mcrypt/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static"

DEPEND="
	>=app-crypt/mhash-0.8.18-r1
	static? ( app-crypt/mhash[static-libs(+)] )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PV}-manpage-fixes.patch
	"${FILESDIR}"/${P}-binary-files.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-C99-decls.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static static-link)
}

src_install() {
	default
	dodoc doc/sample.shashrc doc/FORMAT
	newbashcomp "${FILESDIR}"/shash.bash-completion ${PN}
}
