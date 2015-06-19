# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/gentoo-init/gentoo-init-0.1.ebuild,v 1.12 2014/08/10 20:41:49 slyfox Exp $

EAPI="3"

DESCRIPTION="Simple ASDF-BINARY-LOCATIONS configuration for Gentoo Common Lisp ports"
HOMEPAGE="http://www.gentoo.org/proj/en/lisp/common-lisp/guide.xml"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

S=${WORKDIR}

DEPEND="dev-lisp/asdf-binary-locations"
RDEPEND="${DEPEND}"

src_install() {
	insinto /etc
	doins "${FILESDIR}"/gentoo-init.lisp
}
