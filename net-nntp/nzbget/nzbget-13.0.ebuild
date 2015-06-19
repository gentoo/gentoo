# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/nzbget/nzbget-13.0.ebuild,v 1.1 2014/08/04 16:51:50 radhermit Exp $

EAPI=5

inherit autotools user eutils

MY_P=${P/_pre/-testing-r}

DESCRIPTION="A command-line based binary newsgrapper supporting .nzb files"
HOMEPAGE="http://nzbget.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug gnutls ncurses parcheck ssl zlib"

RDEPEND="dev-libs/libxml2
	ncurses? ( sys-libs/ncurses )
	parcheck? (
		app-arch/libpar2
		dev-libs/libsigc++:2
	)
	ssl? (
		gnutls? ( net-libs/gnutls )
		!gnutls? ( dev-libs/openssl )
	)
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README nzbget.conf )

S=${WORKDIR}/${P/_pre*/-testing}

src_prepare() {
	sed -i 's:^ScriptDir=.*:ScriptDir=/usr/share/nzbget/ppscripts:' nzbget.conf || die

	sed \
		-e 's:^MainDir=.*:MainDir=/var/lib/nzbget:' \
		-e 's:^LockFile=.*:LockFile=/run/nzbget/nzbget.pid:' \
		-e 's:^LogFile=.*:LogFile=/var/log/nzbget/nzbget.log:' \
		-e 's:^WebDir=.*:WebDir=/usr/share/nzbget/webui:' \
		-e 's:^ConfigTemplate=.*:ConfigTemplate=/usr/share/nzbget/nzbget.conf:' \
		-e 's:^DaemonUsername=.*:DaemonUsername=nzbget:' \
		"${S}"/nzbget.conf > "${S}"/nzbgetd.conf || die

	sed -i "/^dist_doc_DATA/d" Makefile.am || die

	epatch "${FILESDIR}"/${PN}-13.0_pre1042-gzip-endif.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable ncurses curses) \
		$(use_enable parcheck) \
		--disable-libpar2-bugfixes-check \
		$(use_enable ssl tls) \
		$(use_enable zlib gzip) \
		--with-tlslib=$(usex gnutls GnuTLS OpenSSL)
}

src_install() {
	default

	# remove unneeded service script
	rm "${D}"/usr/sbin/nzbgetd || die

	insinto /etc
	doins nzbget.conf
	doins nzbgetd.conf

	keepdir /var/lib/nzbget/{dst,nzb,queue,tmp}
	keepdir /var/log/nzbget

	newinitd "${FILESDIR}"/nzbget.initd nzbget
	newconfd "${FILESDIR}"/nzbget.confd nzbget
}

pkg_preinst() {
	enewgroup nzbget
	enewuser nzbget -1 -1 /var/lib/nzbget nzbget

	fowners nzbget:nzbget /var/lib/nzbget/{dst,nzb,queue,tmp}
	fperms 750 /var/lib/nzbget/{queue,tmp}
	fperms 770 /var/lib/nzbget/{dst,nzb}

	fowners nzbget:nzbget /var/log/nzbget
	fperms 750 /var/log/nzbget

	fowners nzbget:nzbget /etc/nzbgetd.conf
	fperms 640 /etc/nzbgetd.conf
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog
		elog "Please add users that you want to be able to use the system-wide"
		elog "nzbget daemon to the nzbget group. To access the daemon run nzbget"
		elog "with the --configfile /etc/nzbgetd.conf option."
		elog
	fi
}
