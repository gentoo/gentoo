# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portpeek/portpeek-2.0.25.ebuild,v 1.8 2013/07/29 19:56:28 mpagano Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="A helper program for maintaining the package.keyword and package.unmask files"
HOMEPAGE="http://www.mpagano.com/blog/?page_id=3"
SRC_URI="http://www.mpagano.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=">=app-portage/gentoolkit-0.3.0.6-r3
	>=sys-apps/portage-2.1.11.9"

src_install() {
	dobin ${PN} || die "dobin failed"
	doman *.[0-9]
}
