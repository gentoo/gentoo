# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils flag-o-matic user

MY_PV=${PV/_pre/-r}
MY_P=${PN}-${PV/_pre/-testing-r}

DESCRIPTION="A command-line based binary newsgrabber supporting .nzb files"
HOMEPAGE="http://nzbget.net/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${MY_PV}/${MY_P}-src.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="debug gnutls ncurses parcheck ssl test zlib"

RDEPEND="dev-libs/libxml2
	ncurses? ( sys-libs/ncurses:0 )
	ssl? (
		gnutls? ( net-libs/gnutls )
		!gnutls? ( dev-libs/openssl:0= )
	)
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
DOCS=( ChangeLog README nzbget.conf )

PATCHES=(
	"${FILESDIR}"/${P}_parcheck-tests-fix.patch
)

S=${WORKDIR}/${PN}-${PV/_pre*/-testing}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && ! test-flag-CXX -std=c++14; then
		eerror "${P} requires a C++14-capable compiler. Your current compiler"
		eerror "does not seem to support the -std=c++14 option. Please"
		eerror "upgrade to gcc-4.9 or an equivalent version supporting C++14."
		die "The currently active compiler does not support -std=c++14"
	fi
}

src_prepare() {
	default
	eautoreconf

	sed -i 's:^ScriptDir=.*:ScriptDir=/usr/share/nzbget/ppscripts:' nzbget.conf || die

	sed \
		-e 's:^MainDir=.*:MainDir=/var/lib/nzbget:' \
		-e 's:^LockFile=.*:LockFile=/run/nzbget/nzbget.pid:' \
		-e 's:^LogFile=.*:LogFile=/var/log/nzbget/nzbget.log:' \
		-e 's:^WebDir=.*:WebDir=/usr/share/nzbget/webui:' \
		-e 's:^ConfigTemplate=.*:ConfigTemplate=/usr/share/nzbget/nzbget.conf:' \
		-e 's:^DaemonUsername=.*:DaemonUsername=nzbget:' \
		nzbget.conf > nzbgetd.conf || die
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable ncurses curses) \
		$(use_enable parcheck) \
		$(use_enable ssl tls) \
		$(use_enable zlib gzip) \
		$(use_enable test tests) \
		--with-tlslib=$(usex gnutls GnuTLS OpenSSL)
}

src_test() {
	./nzbget --tests || die "Tests failed"
}

src_install() {
	default

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
