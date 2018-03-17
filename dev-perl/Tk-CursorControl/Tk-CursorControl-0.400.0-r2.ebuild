# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DUNNIGANJ
DIST_VERSION=0.4

# https://rt.cpan.org/Ticket/Display.html?id=124794
# DIST_EXAMPLES=( "demos/*" )
inherit eutils perl-module virtualx

DESCRIPTION="Manipulate the mouse cursor programmatically"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-perl/Tk"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.4-nodemo.patch" )

src_prepare() {
	perl-module_src_prepare
	edos2unix "${S}"/{CursorControl.pm,demos/cursor.pl}
}
src_test() {
	virtx perl-module_src_test
}
