# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=OESTERHOL
MODULE_VERSION=0.15
inherit virtualx perl-module

DESCRIPTION="Perl binding for the GTK2 AppIndicator"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Gtk2-1.200.0
	dev-libs/libappindicator:2
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	virtx perl-module_src_test
}
SRC_TEST="do parallel"
