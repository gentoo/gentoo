# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TODDR
DIST_VERSION=2.51
inherit perl-module

DESCRIPTION="A perl module for parsing XML documents"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-libs/expat-2.4.0
	dev-perl/File-ShareDir
	dev-perl/libwww-perl
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}
	>=dev-perl/Devel-CheckLib-1.140.0
"

PERL_RM_FILES=(
	"t/checklib_findcc.t"
	"t/checklib_tmpdir.t"
)

src_prepare() {
	perl-module_src_prepare

	# Drop bundled CheckLib which breaks Expat detection
	# bug #827966
	rm inc/Devel/CheckLib.pm || die
}

src_configure() {
	myconf="EXPATLIBPATH=${ESYSROOT}/usr/$(get_libdir) EXPATINCPATH=${ESYSROOT}/usr/include"
	perl-module_src_configure
}

src_install() {
	perl-module_src_install

	# "special" test for bug #827966
	einfo "Checking for Expat.so (bug #827966)"
	find "${D}" -name Expat.so | grep Expat || die "Something went badly wrong, can't find Expat.so. Please file a bug."
}
