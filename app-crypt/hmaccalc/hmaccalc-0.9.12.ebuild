# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/hmaccalc/hmaccalc-0.9.12.ebuild,v 1.2 2014/08/04 03:52:42 robbat2 Exp $

EAPI=3
inherit eutils multilib

DESCRIPTION="Tools for computing and checking HMAC values for files"
HOMEPAGE="https://fedorahosted.org/hmaccalc/"
SRC_URI="https://fedorahosted.org/released/hmaccalc/hmaccalc-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/nss
		sys-devel/prelink"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--enable-sum-directory=/usr/$(get_libdir)/${PN}/ \
	|| die "econf failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc README
}
