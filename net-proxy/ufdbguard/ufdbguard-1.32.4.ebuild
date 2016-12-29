# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils flag-o-matic user

MY_P="ufdbGuard-${PV}"

DESCRIPTION="ufdbGuard is a redirector for the Squid internet proxy"
HOMEPAGE="http://www.urlfilterdb.com/en/products/ufdbguard.html"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/${PV/\.?/}/ReferenceManual.pdf -> ${P}-manual.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +httpd"

COMMON_DEPEND="
	app-arch/bzip2
	dev-libs/openssl:0=
	net-misc/wget
"
DEPEND="${COMMON_DEPEND}
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/openrc
"

DOCS=( CHANGELOG README src/sampleufdbGuard.conf )

PATCHES=( "${FILESDIR}"/${PN}-1.24-gentoo.patch )

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup squid
	enewuser squid -1 -1 /var/cache/squid squid
}

src_configure() {
	# better safe than sorry, the code has a number of possible
	# breakage, and at least one certain breakage.
	append-flags -fno-strict-aliasing

	econf \
		--with-ufdb-user=squid \
		--with-ufdb-config="${EPREFIX}"/etc \
		--with-ufdb-bindir="${EPREFIX}"/usr/libexec/ufdbguard \
		--with-ufdb-logdir="${EPREFIX}"/var/log/ufdbguard \
		--with-ufdb-dbhome="${EPREFIX}"/usr/share/ufdbguard/blacklists \
		--with-ufdb-images_dir="${EPREFIX}"/usr/share/ufdbguard/images
}

src_install() {
	einstalldocs
	doman doc/*.1

	dobin src/ufdbAnalyse src/ufdbGenTable src/ufdbGrab \
		src/ufdbConvertDB
	dosbin src/ufdbUpdate

	exeinto /usr/libexec/ufdbguard
	doexe src/mtserver/ufdbguardd src/mtserver/ufdbgclient

	if use httpd; then
		exeinto /usr/libexec/ufdbguard
		doexe src/ufdbhttpd
	fi

	keepdir /usr/share/ufdbguard/blacklists

	insinto /etc
	doins src/ufdbGuard.conf

	insinto /usr/share/ufdbguard/images
	doins -r src/images/.

	newconfd "${FILESDIR}"/ufdb.confd ufdb
	newinitd "${FILESDIR}"/ufdb.initd.2 ufdb

	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/ufdbUpdate.cron ufdbUpdate

	use doc && newdoc "${DISTDIR}"/${P}-manual.pdf ReferenceManual.pdf
}

pkg_postinst() {
	elog "The default location for the blacklist database has been"
	elog "moved to ${EROOT%/}/usr/share/ufdbguard/blacklists."
	elog ""
	elog "The configuration file is no longer configurable in the"
	elog "service file, and now resides at ${EROOT%/}/etc/ufdbGuard.conf ."
	elog ""
	elog "The service script has been renamed from ufdbguad to simply"
	elog "${EROOT%/}/etc/init.d/ufdb, to follow the official documentation, and"
	elog "it gained a reload option with a reconfig alias."
	elog ""
	elog "You can configure the username and password parameters for"
	elog "ufdbUpdate, to fetch the blacklist database provided by"
	elog "URLfilterDB, directly in ${EROOT%/}/etc/conf.d/ufdb without touching"
	elog "the script itself."
	elog ""
	elog "To enable ufdbguard in squid, you should add this to your"
	elog "squid.conf:"
	elog ""
	elog "    url_rewrite_program ${EROOT%/}/usr/libexec/ufdbguard/ufdbgclient -l ${EROOT%/}/var/log/ufdbguard"
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
		elog "    ${EROOT%/}/usr/share/doc/${PF}/ReferenceManual.pdf"
	fi
}
