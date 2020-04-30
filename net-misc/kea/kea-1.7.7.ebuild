# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="${PV//_p/-P}"
MY_PV="${MY_PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="High-performance production grade DHCPv4 & DHCPv6 server"
HOMEPAGE="http://www.isc.org/kea/"
if [[ ${PV} = 9999* ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/isc-projects/kea.git"
else
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

src_prepare() {
	default
	[[ ${PV} = *9999 ]] && eautoreconf
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
	newconfd "${FILESDIR}"/${PN}-confd ${PN}
	newinitd "${FILESDIR}"/${PN}-initd ${PN}
	keepdir /var/{lib,run}/${PN} /var/log
	find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
}
