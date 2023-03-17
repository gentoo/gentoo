# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmail toolchain-funcs

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="https://cr.yp.to/ucspi-tcp.html"
SRC_URI="
	https://cr.yp.to/${PN}/${P}.tar.gz
	mirror://qmail/ucspi-rss.diff
	http://smarden.org/pape/djb/manpages/${P}-man.tar.gz
	http://xs3.b92.net/tomislavr/${P}-rblspp.patch
	ipv6? ( https://www.fefe.de/ucspi/${P}-ipv6.diff20.bz2 )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="ipv6 qmail-spp selinux"
RESTRICT="test"

RDEPEND="
	!app-doc/ucspi-tcp-man
	selinux? ( sec-policy/selinux-ucspitcp )"

src_prepare() {
	eapply "${FILESDIR}"/${PV}-protos.patch
	if use ipv6; then
		eapply "${WORKDIR}"/${P}-ipv6.diff20
		eapply "${FILESDIR}"/${PV}-protos-ipv6.patch
		eapply "${FILESDIR}"/${PV}-tcprules.patch #135571
		eapply "${FILESDIR}"/${PV}-bigendian.patch #18892
		eapply "${FILESDIR}"/${PV}-implicit-int-ipv6.patch
	else
		eapply "${FILESDIR}"/${PV}-protos-no-ipv6.patch
	fi
	eapply "${DISTDIR}"/ucspi-rss.diff
	eapply "${FILESDIR}"/${PV}-rblsmtpd-ignore-on-RELAYCLIENT.patch
	eapply "${DISTDIR}"/${P}-rblspp.patch
	eapply "${FILESDIR}"/${PV}-protos-rblspp.patch
	eapply "${FILESDIR}"/${PV}-large-responses.patch
	eapply "${FILESDIR}"/${PV}-uint-headers.patch
	eapply "${FILESDIR}"/${PV}-ar-ranlib.patch
	eapply "${FILESDIR}"/${PV}-implicit-int.patch

	eapply_user
}

src_configure() {
	qmail_set_cc
	# The AR/RANLIB logic probably should get moved to the qmail eclass.
	# See also the patch above for generating the "makelib" script.
	tc-export AR RANLIB

	echo "${EPREFIX}/usr/" > conf-home || die
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
