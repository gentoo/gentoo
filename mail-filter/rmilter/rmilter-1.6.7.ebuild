# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils user

DESCRIPTION="Another sendmail milter for different mail checks"
SRC_URI="https://github.com/vstakhov/rmilter/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/vstakhov/rmilter"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libpcre
		mail-filter/libmilter
		mail-filter/opendkim
		mail-filter/libspf2"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup rmilter
	enewuser rmilter -1 -1 /var/run/rmilter rmilter
}

src_install() {
	cmake-utils_src_install
	newinitd "${FILESDIR}/rmilter.initd" rmilter
	insinto /etc/rmilter
	newins rmilter.conf.sample rmilter.conf.sample
	newins rmilter-grey.conf rmilter-grey.conf
}
