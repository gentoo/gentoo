# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DUNNIGANJ
DIST_VERSION=0.4

inherit eutils perl-module virtualx

DESCRIPTION="Manipulate the mouse cursor programmatically"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-perl/Tk"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/0.4-demo.patch" )

src_prepare() {
	perl-module_src_prepare
	edos2unix "${S}"/{CursorControl.pm,demos/cursor.pl}
}
src_test() {
	virtx perl-module_src_test
}
