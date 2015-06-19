# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gsutil/gsutil-3.21.ebuild,v 1.1 2013/01/25 05:49:50 vapier Exp $

EAPI="3"

inherit eutils python multilib

DESCRIPTION="command line tool for interacting with cloud storage services"
HOMEPAGE="http://code.google.com/p/gsutil/"
SRC_URI="http://commondatastorage.googleapis.com/pub/${PN}_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}
	>=dev-python/boto-2.7.0"

S=${WORKDIR}/${PN}

src_prepare() {
	# use system boto
	rm -rf boto
	epatch "${FILESDIR}"/${PN}-system-boto.patch

	# trim some cruft
	find gslib third_party -name README -delete
}

src_install() {
	insinto /usr/$(get_libdir)/${PN}
	doins -r gslib gsutil oauth2_plugin third_party CHECKSUM VERSION || die

	dodir /usr/bin
	dosym /usr/$(get_libdir)/${PN}/gsutil /usr/bin/gsutil
	fperms a+x /usr/$(get_libdir)/${PN}/gsutil

	# http://code.google.com/p/gsutil/issues/detail?id=96
	rm "${D}"/usr/$(get_libdir)/${PN}/gslib/commands/test.py || die

	dodoc README
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r cloud{auth,reader}
	fi
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${PN}
}
