# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="The prelude log analyzer"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="icu ssl"

RDEPEND="dev-libs/libpcre
	>=dev-libs/libprelude-5.1.0
	<dev-libs/libprelude-6
	icu? ( dev-libs/icu:= )
	ssl? ( net-libs/gnutls:= )"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-3.1.0-run.patch"
	"${FILESDIR}/${PN}-3.0.0-conf.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myconf=(
		--localstatedir="${EPREFIX}/var"
		$(use_with ssl libgnutls-prefix)
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	rm -rv "${ED}/run" || die "rm failed"
	keepdir /var/${PN}

	find "${D}" -name '*.la' -delete || die

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newtmpfilesd "${FILESDIR}/${PN}.run" "${PN}.conf"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}
