# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils qmail

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="http://cr.yp.to/ucspi-tcp.html"
SRC_URI="
	http://cr.yp.to/${PN}/${P}.tar.gz
	mirror://qmail/ucspi-rss.diff
	http://smarden.org/pape/djb/manpages/${P}-man.tar.gz
	http://xs3.b92.net/tomislavr/${P}-rblspp.patch
	ipv6? ( http://www.fefe.de/ucspi/${P}-ipv6.diff19.bz2 )
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="ipv6 qmail-spp selinux"
RESTRICT="test"

DEPEND=""
RDEPEND="${DEPEND}
	!app-doc/ucspi-tcp-man
	selinux? ( sec-policy/selinux-ucspitcp )"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-protos.patch
	if use ipv6; then
		epatch "${WORKDIR}"/${P}-ipv6.diff19
		epatch "${FILESDIR}"/${PV}-protos-ipv6.patch
		epatch "${FILESDIR}"/${PV}-tcprules.patch #135571
		epatch "${FILESDIR}"/${PV}-bigendian.patch #18892
	else
		epatch "${FILESDIR}"/${PV}-protos-no-ipv6.patch
	fi
	epatch "${DISTDIR}"/ucspi-rss.diff
	epatch "${FILESDIR}"/${PV}-rblsmtpd-ignore-on-RELAYCLIENT.patch
	epatch "${DISTDIR}"/${P}-rblspp.patch
	epatch "${FILESDIR}"/${PV}-protos-rblspp.patch
	epatch "${FILESDIR}"/${PV}-large-responses.patch
	epatch "${FILESDIR}"/${PV}-uint-headers.patch
	epatch "${FILESDIR}"/${PV}-ar-ranlib.patch

	epatch_user
}

src_configure() {
	qmail_set_cc
	# The AR/RANLIB logic probably should get moved to the qmail eclass.
	# See also the patch above for generating the "makelib" script.
	tc-export AR RANLIB

	echo "${EPREFIX}/usr/" > conf-home
}

src_install() {
	dobin tcpserver tcprules tcprulescheck argv0 recordio tcpclient *\@ \
		tcpcat mconnect mconnect-io addcr delcr fixcrio rblsmtpd

	if use qmail-spp; then
		insinto "${QMAIL_HOME}"/plugins
		insopts -m 755
		doins rblspp
	fi

	doman "${WORKDIR}"/${P}-man/*.[1-8]
	dodoc CHANGES FILES README SYSDEPS TARGETS TODO VERSION

	insinto /etc/tcprules.d
	newins "${FILESDIR}"/tcprules-Makefile Makefile
}
