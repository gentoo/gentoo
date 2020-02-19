# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6

DESCRIPTION="Eselect module to maintain vala compiler symlink"
HOMEPAGE="http://code.google.com/p/eselect-vala/"

SRC_URI="https://github.com/Bodyfarm/eselect-vala/raw/master/eselect-vala-0.1.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE=""

RDEPEND="app-admin/eselect
	dev-lang/vala"
DEPEND="${RDEPEND}
	>=sys-devel/m4-1.4.13"

DOCS="AUTHORS README"

src_install() {
	emake DESTDIR="${D}" install
	dodoc ${DOCS}
}
