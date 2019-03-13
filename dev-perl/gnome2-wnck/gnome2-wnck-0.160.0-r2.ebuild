# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_NAME=Gnome2-Wnck
DIST_AUTHOR=TSCH
DIST_VERSION=0.16

inherit perl-module virtualx

DESCRIPTION="Perl interface to the Window Navigator Construction Kit"
HOMEPAGE="http://gtk2-perl.sourceforge.net/ ${HOMEPAGE}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-perl/glib-perl-1.180.0
	>=dev-perl/Gtk2-1.42.0
	>=x11-libs/libwnck-2.20:1"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-PkgConfig-1.03
	>=dev-perl/ExtUtils-Depends-0.2"

src_test() {
	perl_rm_files t/WnckWorkspace.t
	virtx perl-module_src_test
}
