# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools systemd

DESCRIPTION="Bus communication for all Prelude modules"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tcpwrapper xml geoip dbx"

RDEPEND="net-libs/gnutls:=
	~dev-libs/libprelude-${PV}
	dbx? ( ~dev-libs/libpreludedb-${PV} )
	tcpwrapper? ( sys-apps/tcp-wrappers )
	xml? ( dev-libs/libxml2 )
	geoip? ( dev-libs/libmaxminddb )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-run.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}/var" \
		$(use_with dbx libpreludedb-prefix) \
		$(use_with tcpwrapper libwrap) \
		$(use_with xml xml-prefix) \
		$(use_enable geoip libmaxminddb)
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
