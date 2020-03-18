# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=XAOC
DIST_VERSION=0.034
inherit perl-module virtualx

DESCRIPTION="Perl interface to the 3.x series of the gtk+ toolkit"
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	x11-libs/gtk+:3[introspection]
	>=dev-perl/Cairo-GObject-1.0.0
	virtual/perl-Carp
	virtual/perl-Exporter
	>=dev-perl/Glib-Object-Introspection-0.43.0

"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.30
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"

PATCHES=(
	# Fixed in next version, bug #683046
	"${FILESDIR}"/${P}-gdk-pixbuf-test.patch
)

src_test() {
	virtx perl-module_src_test
}
