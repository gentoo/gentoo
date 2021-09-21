# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV//_p/-P}"
MY_PV="${MY_PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="High-performance production grade DHCPv4 & DHCPv6 server"
HOMEPAGE="http://www.isc.org/kea/"

inherit autotools systemd tmpfiles

if [[ ${PV} = 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/isc-projects/kea.git"
else
	SRC_URI="ftp://ftp.isc.org/isc/kea/${MY_P}.tar.gz
		ftp://ftp.isc.org/isc/kea/${MY_PV}/${MY_P}.tar.gz"
	[[ "${PV}" == *_beta* ]] || [[ "${PV}" == *_rc* ]] || \
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="ISC BSD SSLeay GPL-2" # GPL-2 only for init script
SLOT="0"
IUSE="mysql +openssl postgres +samples test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/boost:=
	dev-libs/log4cplus
	mysql? ( dev-db/mysql-connector-c )
	!openssl? ( dev-libs/botan:2= )
	openssl? ( dev-libs/openssl:0= )
	postgres? ( dev-db/postgresql:* )
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-cpp/gtest )"
RDEPEND="${COMMON_DEPEND}
	acct-group/dhcp
	acct-user/dhcp"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.2-fix-cxx11-detection.patch
	"${FILESDIR}"/${PN}-1.8.2-boost-1.77.0.patch
	"${FILESDIR}"/${PN}-1.8.2-gtest.patch
)

src_prepare() {
	default
	# Brand the version with Gentoo
	sed -i \
		-e "s/AC_INIT(kea,${PV}.*, kea-dev@lists.isc.org)/AC_INIT(kea,${PVR}-gentoo, kea-dev@lists.isc.org)/g" \
		configure.ac || die

	sed -i \
		-e '/mkdir -p $(DESTDIR)${runstatedir}\/${PACKAGE_NAME}/d' \
		Makefile.am || die "Fixing Makefile.am failed"

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-install-configurations
		--disable-static
		--enable-perfdhcp
		--localstatedir="${EPREFIX}/var"
		--runstatedir="${EPREFIX}/run"
		--without-werror
		$(use_with mysql)
		$(use_with openssl)
		$(use_with postgres pgsql)
		$(use_enable test gtest)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	newconfd "${FILESDIR}"/${PN}-confd-r1 ${PN}
	newinitd "${FILESDIR}"/${PN}-initd-r1 ${PN}

	if use samples; then
		diropts -m 0750 -o root -g dhcp
		dodir /etc/kea
		insopts -m 0640 -o root -g dhcp
		insinto /etc/kea
		doins "${FILESDIR}"/${PN}-ctrl-agent.conf
		doins "${FILESDIR}"/${PN}-ddns-server.conf
		doins "${FILESDIR}"/${PN}-dhcp4.conf
		doins "${FILESDIR}"/${PN}-dhcp6.conf
	fi

	systemd_dounit "${FILESDIR}"/${PN}-ctrl-agent.service
	systemd_dounit "${FILESDIR}"/${PN}-ddns-server.service
	systemd_dounit "${FILESDIR}"/${PN}-dhcp4-server.service
	systemd_dounit "${FILESDIR}"/${PN}-dhcp6-server.service

	newtmpfiles "${FILESDIR}"/${PN}.tmpfiles.conf ${PN}.conf

	keepdir /var/lib/${PN} /var/log/${PN}
	find "${ED}" -type f -name "*.la" -delete || die
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
