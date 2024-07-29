# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd tmpfiles

DESCRIPTION="A lightweight HTTP/SSL proxy"
HOMEPAGE="https://github.com/tinyproxy/tinyproxy/"
SRC_URI="https://github.com/tinyproxy/tinyproxy/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~sparc x86"

IUSE="test debug +filter-proxy reverse-proxy transparent-proxy
+upstream-proxy +xtinyproxy-header"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( xtinyproxy-header )"

DEPEND="
	acct-group/tinyproxy
	acct-user/tinyproxy
"

RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i \
		-e "s|nobody|${PN}|g" \
		etc/${PN}.conf.in || die "sed failed"

	sed -i -e "s# -Wp,-D_FORTIFY_SOURCE=2##" configure.ac || die "sed failed"

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable filter-proxy filter) \
		$(use_enable reverse-proxy reverse) \
		$(use_enable transparent-proxy transparent) \
		$(use_enable upstream-proxy upstream) \
		$(use_enable xtinyproxy-header xtinyproxy) \
		--localstatedir=/var
}

src_test() {
	# The make check target does not run the test suite
	emake test
}

src_install() {
	default

	dodoc AUTHORS README.md

	diropts -m0775 -o ${PN} -g ${PN}
	keepdir /var/log/${PN}

	newinitd "${FILESDIR}"/${PN}-1.10.0.initd tinyproxy
	systemd_newunit "${FILESDIR}"/${PN}-1.10.0.service tinyproxy.service
	dotmpfiles "${FILESDIR}"/${PN}.tmpfiles.conf
}

pkg_postinst() {
	tmpfiles_process ${PN}.tmpfiles.conf

	elog "For filtering domains and URLs, enable filter option in the configuration"
	elog "file and add them to the filter file (one domain or URL per line)."
}
