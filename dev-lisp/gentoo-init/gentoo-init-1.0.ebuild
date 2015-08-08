# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
