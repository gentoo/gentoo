# Copyright 1999-2016 Gentoo Foundation
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
IUSE="dkim libressl +memcached"

RDEPEND="dev-libs/libpcre
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	mail-filter/libmilter
	>=dev-libs/glib-2.28
	dkim? ( mail-filter/opendkim )
	memcached? ( dev-libs/libmemcached )"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup rmilter
	enewuser rmilter -1 -1 /var/run/rmilter rmilter
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DKIM=$(usex dkim ON OFF)
		-DENABLE_MEMCACHED=$(usex memcached ON OFF)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newinitd "${FILESDIR}/rmilter.initd" rmilter
	insinto /etc/rmilter
	newins rmilter.conf.sample rmilter.conf.sample
	newins rmilter-grey.conf rmilter-grey.conf
}
