# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs autotools systemd user

[ "${PV##*_}" = "beta" ] &&
	PRIVOXY_STATUS="beta" ||
	PRIVOXY_STATUS="stable"

HOMEPAGE="http://www.privoxy.org http://sourceforge.net/projects/ijbswa/"
DESCRIPTION="A web proxy with advanced filtering capabilities for enhancing privacy"
SRC_URI="mirror://sourceforge/ijbswa/${P%_*}-${PRIVOXY_STATUS}-src.tar.gz"

IUSE="+acl editor external-filters +fast-redirects +force graceful-termination
+image-blocking ipv6 lfs png-images selinux +stats +threads toggle
whitelists +zlib"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
LICENSE="GPL-2"

DEPEND="dev-libs/libpcre
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-privoxy )"

REQUIRED_USE="toggle? ( editor )"

S="${WORKDIR}/${P%_*}-${PRIVOXY_STATUS}"

pkg_setup() {
	enewgroup privoxy
	enewuser privoxy -1 -1 /etc/privoxy privoxy
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.0.19-gentoo.patch
	# autoreconf needs to be called even if we don't modify any autotools source files
	# See main makefile
	eautoreconf
}

src_configure() {

	econf \
		$(use_enable acl acl-support) \
		$(use_enable editor) \
		$(use_enable fast-redirects) \
		$(use_enable force) \
		$(use_enable graceful-termination) \
		$(use_enable image-blocking) \
		$(use_enable ipv6 ipv6-support) \
		$(use_enable lfs large-file-support) \
		$(use_enable png-images no-gifs) \
		$(use_enable stats) \
		$(use_enable threads pthread) \
		$(use_enable toggle) \
		$(use_enable whitelists trust-files) \
		$(use_enable zlib) \
		$(usex zlib --enable-compression "") \
		--enable-dynamic-pcre \
		--with-user=privoxy \
		--with-group=privoxy \
		--sysconfdir=/etc/privoxy \
		--docdir=/usr/share/doc/${PF}
}

src_install () {
	default

	newinitd "${FILESDIR}/privoxy.initd" privoxy
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc/logrotate.d
	newins "${FILESDIR}/privoxy.logrotate" privoxy

	diropts -m 0750 -g privoxy -o privoxy
	keepdir /var/log/privoxy
}
