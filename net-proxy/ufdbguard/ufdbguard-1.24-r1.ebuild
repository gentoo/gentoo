# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/ufdbguard/ufdbguard-1.24-r1.ebuild,v 1.6 2015/04/24 10:18:43 eras Exp $

EAPI="2"

inherit eutils user

MY_P="ufdbGuard-${PV}"

DESCRIPTION="ufdbGuard is a redirector for the Squid internet proxy"
HOMEPAGE="http://www.urlfilterdb.com/en/products/ufdbguard.html"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/ReferenceManual_v${PV/\./_}.pdf -> ${P}-manual.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="+httpd doc"

RDEPEND="dev-libs/openssl
	app-arch/bzip2
	net-misc/wget"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

RDEPEND="${RDEPEND}
	sys-apps/openrc"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup squid
	enewuser squid -1 -1 /var/cache/squid squid
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.23-parallel-make.patch
	epatch "${FILESDIR}"/${P}-gentoo.patch

	egrep -r -e '/var/tmp/ufdb(guard|http)d.pid' "${S}" -lZ | xargs -0 \
		sed -i -e 's:/var/tmp/ufdb\(guard\|http\)d.pid:/var/run/ufdbguard/ufdb\1d.pid:' \
		|| die

	# directory where ufdbhttpd is to be found
	sed -i -e 's:DEFAULT_BINDIR.*:DEFAULT_BINDIR "/usr/libexec/ufdbguard":' \
		src/ufdb.h.in || die
}

src_configure() {
	econf \
		--with-ufdb-user=squid \
		--with-ufdb-config=/etc \
		--with-ufdb-logdir=/var/log/ufdbguard \
		--with-ufdb-dbhome=/usr/share/ufdbguard/blacklists \
		--with-ufdb-images_dir=/usr/share/ufdbguard/images
}

src_install() {
	dodoc CHANGELOG INSTALL README src/sampleufdbGuard.conf || die
	doman doc/*.1 || die

	dobin src/ufdbAnalyse src/ufdbGenTable src/ufdbGrab \
		src/ufdbConvertDB || die
	dosbin src/ufdbUpdate || die

	exeinto /usr/libexec/ufdbguard
	doexe src/mtserver/ufdbguardd src/mtserver/ufdbgclient || die

	if use httpd; then
		exeinto /usr/libexec/ufdbguard
		doexe src/ufdbhttpd || die
	fi

	keepdir /usr/share/ufdbguard/blacklists

	insinto /etc
	doins src/ufdbGuard.conf || die

	insinto /usr/share/ufdbguard/images
	doins src/images/* || die

	newconfd "${FILESDIR}"/ufdb.confd ufdb || die
	newinitd "${FILESDIR}"/ufdb.initd ufdb || die

	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/ufdbUpdate.cron ufdbUpdate || die

	if use doc; then
		insinto /usr/share/doc/${PF}
		newins "${DISTDIR}"/${P}-manual.pdf ReferenceManual.pdf || die
	fi
}

pkg_postinst() {
	elog "The default location for the blacklist database has been"
	elog "moved to /usr/share/ufdbguard/blacklists."
	elog ""
	elog "The configuration file is no longer configurable in the"
	elog "service file, and now resides at /etc/ufdbGuard.conf ."
	elog ""
	elog "The service script has been renamed from ufdbguad to simply"
	elog "/etc/init.d/ufdb, to follow the official documentation, and"
	elog "it gained a reload option with a reconfig alias."
	elog ""
	elog "You can configure the username and password parameters for"
	elog "ufdbUpdate, to fetch the blacklist database provided by"
	elog "URLfilterDB, directly in /etc/conf.d/ufdb without touching"
	elog "the script itself."
	elog ""
	elog "To enable ufdbguard in squid, you should add this to your"
	elog "squid.conf:"
	elog ""
	elog "    url_rewrite_program /usr/libexec/ufdbguard/ufdbgclient -l /var/log/ufdbguard"
	elog "    url_rewrite_children 64"
	elog ""
	if ! use httpd; then
		elog "You chose to not install the lightweight http daemon that"
		elog "comes with ufdbguard."
	else
		elog "The ufdb service will start both the ufdbguardd daemon and"
		elog "the ufdbhttpd http daemon to provide a local redirect CGI."
		elog "If you don't want this to happen, disable the httpd USE flag."
	fi
	if use doc; then
		elog ""
		elog "The reference manual has been installed as"
		elog "    /usr/share/doc/${PF}/ReferenceManual.pdf"
	fi
}
