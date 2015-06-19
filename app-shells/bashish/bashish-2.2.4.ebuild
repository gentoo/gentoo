# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/bashish/bashish-2.2.4.ebuild,v 1.7 2013/08/27 20:09:02 jer Exp $

EAPI=5

DESCRIPTION="Text console theme engine"
HOMEPAGE="http://bashish.sourceforge.net/"
SRC_URI="mirror://sourceforge/bashish/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE=""

RDEPEND=">=dev-util/dialog-1.0"

src_install() {
	default
	mv "${D}"/usr/share/doc/{${PN},${PF}} || die "mv docs failed"
}
