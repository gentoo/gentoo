# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RMCFARLA
DIST_VERSION=0.50
DIST_SECTION=Gtk2-Perl-Ex
DIST_EXAMPLES=( "examples/*" )
inherit perl-module virtualx

DESCRIPTION="A simple interface to Gtk2's complex MVC list widget"

LICENSE="|| ( LGPL-2.1 LGPL-3 )" # LGPL-2.1+
SLOT="0"
KEYWORDS="amd64 ia64 sparc x86"
IUSE=""

RDEPEND="
	>=dev-perl/Gtk2-1.60.0
	>=dev-perl/glib-perl-1.62.0
"
DEPEND="${RDEPEND}"

src_test() {
	virtx perl-module_src_test
}
