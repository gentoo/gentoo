# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Utility to select the default Electron slot"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://github.com/elprans/${PN}/archive/v${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~ppc-macos ~x86-solaris"
IUSE=""

RDEPEND="app-admin/eselect"

src_install() {
	keepdir /etc/eselect/electron

	insinto /usr/share/eselect/modules
	doins electron.eselect
}

pkg_postinst() {
	eselect electron update
}
