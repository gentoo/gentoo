# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/gentoo-init/gentoo-init-1.0.ebuild,v 1.4 2015/05/23 15:15:30 pacho Exp $

EAPI=4

DESCRIPTION="Simple ASDF2 configuration for Gentoo Common Lisp ports"
HOMEPAGE="http://www.gentoo.org/proj/en/lisp/common-lisp/guide.xml"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND=">=dev-lisp/asdf-2.0"

S="${WORKDIR}"

src_install() {
	insinto /etc/common-lisp
	newins "${FILESDIR}"/gentoo-init-1.lisp gentoo-init.lisp
	doins  "${FILESDIR}"/source-registry.conf
}
