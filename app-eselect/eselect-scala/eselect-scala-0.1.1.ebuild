# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-scala/eselect-scala-0.1.1.ebuild,v 1.3 2015/05/27 11:18:44 ago Exp $

EAPI=5

DESCRIPTION="Manages multiple Scala versions"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~gienah/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND=">=app-admin/eselect-1.0.2"

src_install() {
	insinto /usr/share/eselect/modules
	doins scala.eselect
}
