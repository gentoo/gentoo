# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV//_p/-P}"
MY_PV="${MY_PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="High-performance production grade DHCPv4 & DHCPv6 server"
HOMEPAGE="http://www.isc.org/kea/"
if [[ ${PV} = 9999* ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/isc-projects/kea.git"
else
	inherit autotools
	SRC_URI="ftp://ftp.isc.org/isc/kea/${MY_P}.tar.gz
		ftp://ftp.isc.org/isc/kea/${MY_PV}/${MY_P}.tar.gz"
	[[ "${PV}" == *_beta* ]] || [[ "${PV}" == *_rc* ]] || \
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="ISC BSD SSLeay GPL-2" # GPL-2 only for init script
SLOT="0"
IUSE="mysql +openssl postgres samples"

DEPEND="
	dev-libs/boost:=
	dev-cpp/gtest
	dev-libs/log4cplus
	mysql? ( dev-db/mysql-connector-c )
	!openssl? ( dev-libs/botan:2= )
	openssl? ( dev-libs/openssl:0= )
	postgres? ( dev-db/postgresql:* )
"
RDEPEND="${DEPEND}
	acct-group/dhcp
	acct-user/dhcp"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-1.8.2-fix-cxx11-detection.patch )

src_prepare() {
	default
	eautoreconf
	# Brand the version with Gentoo
	sed -i \
		-e "/VERSION=/s:'$: Gentoo-${PR}':" \
		configure || die
}

src_configure() {
	local myeconfargs=(
		--disable-static
		--enable-perfdhcp
		--localstatedir="${EPREFIX}/var"
		--without-werror
		$(use_with mysql)
		$(use_with openssl)
		$(use_with postgres pgsql)
		$(use_enable samples install-configurations)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	newconfd "${FILESDIR}"/${PN}-confd-r1 ${PN}
	newinitd "${FILESDIR}"/${PN}-initd-r1 ${PN}
	keepdir /var/lib/${PN} /var/log
	rm -rf "${ED}"/var/run || die
	find "${ED}" -type f -name "*.la" -delete || die
}
