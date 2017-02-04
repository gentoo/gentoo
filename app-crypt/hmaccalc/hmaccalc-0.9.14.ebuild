# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit multilib-minimal

DESCRIPTION="Tools for computing and checking HMAC values for files"
HOMEPAGE="https://fedorahosted.org/hmaccalc/"
SRC_URI="https://fedorahosted.org/released/hmaccalc/hmaccalc-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+fips"

DEPEND="dev-libs/nss
		sys-devel/prelink"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--enable-sum-directory=/usr/$(get_libdir)/${PN}/ \
		$(use_enable !fips non-fips)
}
