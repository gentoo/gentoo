# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RATCLIFFE
DIST_VERSION=0.05
DIST_EXAMPLES=( "examples/*" )
inherit perl-module virtualx

DESCRIPTION="Perl binding for the GtkImageView image viewer widget"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/Gtk2
	>=media-gfx/gtkimageview-1.6.3"
DEPEND="${RDEPEND}
	dev-perl/glib-perl
	>=dev-perl/ExtUtils-Depends-0.300
	>=dev-perl/ExtUtils-PkgConfig-1.030"

src_test(){
	perl_rm_files t/pod.t
	virtx perl-module_src_test
}
