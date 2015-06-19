# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ucspi-tcp/ucspi-tcp-0.88-r17.ebuild,v 1.12 2012/05/13 11:18:54 swift Exp $

inherit eutils fixheadtails flag-o-matic qmail

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="http://cr.yp.to/ucspi-tcp.html"
SRC_URI="
	http://cr.yp.to/${PN}/${P}.tar.gz
	mirror://qmail/ucspi-rss.diff
	http://smarden.org/pape/djb/manpages/${P}-man.tar.gz
	http://xs3.b92.net/tomislavr/${P}-rblspp.patch
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="qmail-spp selinux"
RESTRICT="test"

DEPEND=""
RDEPEND="${DEPEND}
	!app-doc/ucspi-tcp-man
	selinux? ( sec-policy/selinux-ucspitcp )"

pkg_setup() {
	if [[ -n "${UCSPI_TCP_PATCH_DIR}" ]]; then
		eerror
		eerror "The UCSPI_TCP_PATCH_DIR variable for custom patches"
		eerror "has been removed from ${PN}. If you need custom patches"
		eerror "you should create a copy of this ebuild in an overlay."
		eerror
		die "UCSPI_TCP_PATCH_DIR is not supported anymore"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PV}-errno.patch
	epatch "${FILESDIR}"/${PV}-exit.patch
	epatch "${DISTDIR}"/ucspi-rss.diff
	epatch "${FILESDIR}"/${PV}-rblsmtpd-ignore-on-RELAYCLIENT.patch
	epatch "${DISTDIR}"/${P}-rblspp.patch

	ht_fix_file Makefile

	# gcc-3.4.5 and other several versions contain a bug on some platforms that
	# cause this error:
	# tcpserver: fatal: temporarily unable to figure out IP address for 0.0.0.0: file does not exist
	# To work around this, we use -O1 here instead.
	replace-flags -O? -O1

	qmail_set_cc
	echo "/usr/" > conf-home

	# allow larger responses
	sed -i -e 's|if (text.len > 200) text.len = 200;|if (text.len > 500) text.len = 500;|g' \
		rblsmtpd.c rblspp.c
}

src_compile() {
	emake || die
}

src_install() {
	dobin tcpserver tcprules tcprulescheck argv0 recordio tcpclient *\@ \
		tcpcat mconnect mconnect-io addcr delcr fixcrio rblsmtpd || die

	if use qmail-spp; then
		insinto "${QMAIL_HOME}"/plugins
		insopts -m 755
		doins rblspp
	fi

	doman "${WORKDIR}"/${P}-man/*.[1-8]
	dodoc CHANGES FILES README SYSDEPS TARGETS TODO VERSION

	insinto /etc/tcprules.d/
	newins "${FILESDIR}"/tcprules-Makefile Makefile
}

pkg_postinst() {
	einfo
	einfo "We have started a move to get all tcprules files into"
	einfo "/etc/tcprules.d/, where we have provided a Makefile to"
	einfo "easily update the CDB file."
	einfo
}
