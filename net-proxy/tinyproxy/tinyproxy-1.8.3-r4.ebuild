# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools systemd user

DESCRIPTION="A lightweight HTTP/SSL proxy"
HOMEPAGE="http://www.banu.com/tinyproxy/"
SRC_URI="http://www.banu.com/pub/${PN}/1.8/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc sparc x86"

IUSE="test debug +filter-proxy minimal reverse-proxy
	transparent-proxy +upstream-proxy +xtinyproxy-header"

REQUIRED_USE="test? ( xtinyproxy-header )"

DEPEND="!minimal? ( app-text/asciidoc )"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} "" "" "" ${PN}
}

src_prepare() {
	default

	eapply "${FILESDIR}"/${PN}-1.8.1-ldflags.patch
	eapply "${FILESDIR}"/${P}-r2-DoS-Prevention.patch

	use minimal && epatch "${FILESDIR}/${PN}-1.8.1-minimal.patch"

	sed -i \
		-e "s|nobody|${PN}|g" \
		-e 's|/var/run/|/run/|g' \
		etc/${PN}.conf.in || die "sed failed"

	sed -i \
		-e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' \
		configure.ac || die

	eautoreconf
}

src_configure() {
	if use minimal; then
		ln -s /bin/true "${T}"/a2x
		export PATH="${T}:${PATH}"
	fi

	econf \
		$(use_enable debug) \
		$(use_enable filter-proxy filter) \
		$(use_enable reverse-proxy reverse) \
		$(use_enable transparent-proxy transparent) \
		$(use_enable upstream-proxy upstream) \
		$(use_enable xtinyproxy-header xtinyproxy) \
		--disable-silent-rules \
		--localstatedir=/var
}

src_test() {
	# The make check target does not run the test suite
	emake test
}

src_install() {
	default

	dodoc AUTHORS ChangeLog NEWS README TODO

	diropts -m0775 -o ${PN} -g ${PN}
	keepdir /var/log/${PN}

	newinitd "${FILESDIR}"/${PN}-1.8.3-r2.initd tinyproxy
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_dotmpfilesd "${FILESDIR}"/${PN}.tmpfiles.conf
}

pkg_postinst() {
	elog "For filtering domains and URLs, enable filter option in the configuration"
	elog "file and add them to the filter file (one domain or URL per line)."
}
