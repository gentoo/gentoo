# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=REHSACK
DIST_VERSION=0.428
inherit perl-module

DESCRIPTION="Provide the missing functionality from List::Util"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="test +xs"
RESTRICT="!test? ( test )"
# See MoreUtils.pm/LICENSE
LICENSE="Apache-2.0 || ( Artistic GPL-1+ )"

PDEPEND="xs? ( >=dev-perl/List-MoreUtils-XS-0.426.0 )"
RDEPEND=">=dev-perl/Exporter-Tiny-0.38.0"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Storable
		>=virtual/perl-Test-Simple-0.960.0
	)
"
PATCHES=("${FILESDIR}/${PN}-0.426.0-xs-config.patch")
src_configure() {
	export LMU_USE_XS="$(usex xs 1 0)"
	perl-module_src_configure
}
