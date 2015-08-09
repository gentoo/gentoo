# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multilib flag-o-matic

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="C Implementation of an ICAP server"
HOMEPAGE="http://c-icap.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="berkdb ipv6 ldap"

RDEPEND="berkdb? ( sys-libs/db )
	ldap? ( net-nds/openldap )
	sys-libs/zlib"

DEPEND="${RDEPEND}"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/c-icap-0.2.6-fix-icap-parsing.patch
}

src_configure() {
	# some void *** pointers get casted around and can be troublesome to
	# fix properly.
	append-flags -fno-strict-aliasing

	econf \
		--sysconfdir=/etc/${PN} \
		--disable-dependency-tracking \
		--disable-maintainer-mode \
		--disable-static \
		--enable-large-files \
		$(use_enable ipv6) \
		$(use_with berkdb bdb) \
		$(use_with ldap)
}

src_compile() {
	emake LOGDIR="/var/log"
}

src_install() {
	emake \
		LOGDIR="/var/log" \
		DESTDIR="${D}" install

	find "${D}" -name '*.la' -delete || die

	# Move the daemon out of the way
	dodir /usr/libexec
	mv "${D}"/usr/bin/c-icap "${D}"/usr/libexec || die

	# Remove the default configuration files since we have etc-update to
	# take care of it for us.
	rm "${D}"/etc/${PN}/c-icap.*.default || die

	# Fix the configuration file; for some reason it's a bit messy
	# around.
	sed -i \
		-e 's:/usr/var/:/var/:g' \
		-e 's:/var/log/:/var/log/c-icap/:g' \
		-e 's:/usr/etc/:/etc/c-icap/:g' \
		-e 's:/usr/local/c-icap/etc/:/etc/c-icap/:g' \
		-e 's:/usr/lib/:/usr/'$(get_libdir)'/:g' \
		"${D}"/etc/${PN}/c-icap.conf \
		|| die

	dodoc AUTHORS README TODO ChangeLog

	newinitd "${FILESDIR}/${PN}.init.3" ${PN}
	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	keepdir /var/log/c-icap

	insopts -m0644
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	# avoid triggering portage's symlink protection; this is handled by
	# the init script anyway.
	rm -rf "${D}"/var/run
}

pkg_postinst() {
	elog "To enable Squid to call the ICAP modules from a local server you should set"
	elog "the following in your squid.conf:"
	elog ""
	elog "    icap_enable on"
	elog ""
	elog "    # not strictly needed, but some modules might make use of these"
	elog "    icap_send_client_ip on"
	elog "    icap_send_client_username on"
	elog ""
	elog "    icap_service service_req reqmod_precache bypass=1 icap://localhost:1344/service"
	elog "    adaptation_access service_req allow all"
	elog ""
	elog "    icap_service service_resp respmod_precache bypass=0 icap://localhost:1344/service"
	elog "    adaptation_access service_resp allow all"
	elog ""
	elog "You obviously will have to replace \"service\" with the actual ICAP service to"
	elog "use."
}
