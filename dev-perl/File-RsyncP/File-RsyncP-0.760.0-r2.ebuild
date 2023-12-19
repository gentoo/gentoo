# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CBARRATT
DIST_VERSION=0.76
inherit perl-module toolchain-funcs

DESCRIPTION="An rsync perl module"
HOMEPAGE="https://perlrsync.sourceforge.net/ https://metacpan.org/release/File-RsyncP"
# Bundled files make for some weirdness
LICENSE="GPL-3+ GPL-2+ RSA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=virtual/perl-Getopt-Long-2.240.0
	net-misc/rsync
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.700.0-make.patch"
	"${FILESDIR}/${PN}-0.760.0-lto.patch"
	"${FILESDIR}/${PN}-0.760.0-c99.patch"
)

src_prepare() {
	perl-module_src_prepare
	tc-export CC
}
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
