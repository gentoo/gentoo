# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Manages PACKAGE_MANAGER environment variable"
HOMEPAGE="https://www.gentoo.org/proj/en/eselect/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=app-admin/eselect-1.1.1"

src_install() {
	insinto /usr/share/eselect/modules
	doins package-manager.eselect || die
	doman package-manager.eselect.5 || die
}
