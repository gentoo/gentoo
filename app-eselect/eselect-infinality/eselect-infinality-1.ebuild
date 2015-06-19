# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-infinality/eselect-infinality-1.ebuild,v 1.1 2015/03/31 16:49:24 ulm Exp $

EAPI=4
inherit vcs-snapshot readme.gentoo

DESCRIPTION="Eselect module to choose an infinality font configuration style"
HOMEPAGE="https://github.com/yngwin/eselect-infinality"
SRC_URI="${HOMEPAGE}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-admin/eselect"
DEPEND=""

DOC_CONTENTS="Use eselect infinality to select a font configuration style.
This is supposed to be used in pair with eselect lcdfilter."

src_install() {
	dodoc README.rst
	readme.gentoo_create_doc
	insinto "/usr/share/eselect/modules"
	doins infinality.eselect
}
