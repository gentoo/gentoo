# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hardened-shadow/hardened-shadow-0.9.2.ebuild,v 1.2 2014/01/08 06:15:22 vapier Exp $

EAPI=4

inherit autotools-utils eutils multilib user

DESCRIPTION="Hardened implementation of user account utilities"
HOMEPAGE="http://code.google.com/p/hardened-shadow/"
SRC_URI="http://hardened-shadow.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-libs/pam
	!sys-apps/shadow"
RDEPEND="${DEPEND}
	>=sys-auth/pambase-20120417"

DOCS=( README )

pkg_setup() {
	# The hardened-shadow group is needed at src_install time,
	# so the only place we can create the group is pkg_setup.
	enewgroup hardened-shadow
}

src_install() {
	autotools-utils_src_install

	# Remove pam.d files colliding with pambase.
	rm -r "${ED}"/etc/pam.d || die
}
