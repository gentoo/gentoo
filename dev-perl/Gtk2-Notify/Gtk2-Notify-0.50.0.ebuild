# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=FLORA
DIST_VERSION=0.05
inherit perl-module virtualx

DESCRIPTION="A perl interface to the notification library"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/glib-perl
	dev-perl/Gtk2
	>=x11-libs/libnotify-0.7
"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/ExtUtils-PkgConfig
	test? ( dev-perl/Test-Exception )
"

PATCHES=( "${FILESDIR}"/${PN}-0.05-libnotify.patch )

PERL_RM_FILES=( t/notification.t )
# the test dies if no notification daemon is present...

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

src_test() {
	# bug 416729
	virtx perl-module_src_test
}
