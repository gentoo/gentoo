# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools systemd

DESCRIPTION="Bus communication for all Prelude modules"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbx geoip tcpwrapper xml"

RDEPEND="net-libs/gnutls:=
	~dev-libs/libprelude-${PV}
	dbx? ( ~dev-libs/libpreludedb-${PV} )
	geoip? ( dev-libs/libmaxminddb )
	tcpwrapper? ( sys-apps/tcp-wrappers )
	xml? ( dev-libs/libxml2 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-3.1.0-run.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}/var" \
		$(use_with dbx libpreludedb-prefix) \
		$(use_enable geoip libmaxminddb) \
		$(use_with tcpwrapper libwrap) \
		$(usex xml '' '--without-xml-prefix')
}

src_install() {
	default

	rm -rv "${ED%/}/run" || die "rm failed"
	keepdir /var/spool/prelude-manager{,/failover,/scheduler}

	find "${D}" -name '*.la' -delete || die

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newtmpfilesd "${FILESDIR}/${PN}.run" "${PN}.conf"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}
