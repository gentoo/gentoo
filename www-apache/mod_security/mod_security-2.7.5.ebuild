# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_security/mod_security-2.7.5.ebuild,v 1.2 2014/08/10 20:17:53 slyfox Exp $

EAPI=4

inherit apache-module

MY_PN=modsecurity-apache
MY_PV=${PV/_rc/-rc}
MY_P=${MY_PN}_${MY_PV}

DESCRIPTION="Web application firewall and Intrusion Detection System for Apache"
HOMEPAGE="http://www.modsecurity.org/"
SRC_URI="http://www.modsecurity.org/tarball/${PV}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="geoip curl lua jit"

DEPEND=">=dev-libs/libxml2-2.7.8
	dev-libs/libpcre[jit?]
	lua? ( >=dev-lang/lua-5.1 )
	curl? ( >=net-misc/curl-7.15.1 )
	www-servers/apache[apache2_modules_unique_id]"
RDEPEND="${DEPEND}
	geoip? ( dev-libs/geoip )"
PDEPEND=">=www-apache/modsecurity-crs-2.2.6-r1"

S="${WORKDIR}/${MY_P}"

APACHE2_MOD_FILE="apache2/.libs/${PN}2.so"
APACHE2_MOD_DEFINE="SECURITY"

# Tests require symbols only defined within the Apache binary.
RESTRICT=test

need_apache2

src_prepare() {
	cp "${FILESDIR}"/modsecurity-2.7.conf "${T}"/79_modsecurity.conf || die
}

src_configure() {
	econf \
		--enable-shared --disable-static \
		--with-apxs="${APXS}" \
		--enable-request-early \
		$(use_enable curl mlogc) \
		$(use_with lua) \
		$(use_enable jit pcre-jit)
}

src_compile() {
	if ! use geoip; then
		sed -i -e '/SecGeoLookupDb/s:^:#:' \
			"${T}"/79_modsecurity.conf || die
	fi

	emake
}

src_test() {
	emake check
}

src_install() {
	apache-module_src_install

	# install manually rather than by using the APACHE2_MOD_CONF
	# variable since we have to edit it to set things up properly.
	insinto "${APACHE_MODULES_CONFDIR}"
	doins "${T}"/79_modsecurity.conf

	dodoc CHANGES NOTICE README.TXT README_WINDOWS.TXT

	dohtml -r doc/*

	keepdir /var/cache/modsecurity
	fowners apache:apache /var/cache/modsecurity
	fperms 0770 /var/cache/modsecurity
}

pkg_postinst() {
	if [[ -f "${ROOT}"/etc/apache/modules.d/99_mod_security.conf ]]; then
		ewarn "You still have the configuration file 99_mod_security.conf."
		ewarn "Please make sure to remove that and keep only 79_modsecurity.conf."
		ewarn ""
	fi
	elog "The base configuration file has been renamed 79_modsecurity.conf"
	elog "so that you can put your own configuration as 90_modsecurity_local.conf or"
	elog "equivalent."
	elog ""
	elog "That would be the correct place for site-global security rules."
	elog "Note: 80_modsecurity_crs.conf is used by www-apache/modsecurity-crs"
}
