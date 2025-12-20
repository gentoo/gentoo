# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qmail toolchain-funcs

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="https://cr.yp.to/ucspi-tcp.html"
SRC_URI="
	https://cr.yp.to/${PN}/${P}.tar.gz
	http://qmail.org/ucspi-rss.diff
	http://smarden.org/pape/djb/manpages/${P}-man.tar.gz
	http://xs3.b92.net/tomislavr/${P}-rblspp.patch
	ipv6? ( https://www.fefe.de/ucspi/${P}-ipv6.diff20.bz2 )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="ipv6 qmail-spp selinux"
RESTRICT="test"

RDEPEND="
	selinux? ( sec-policy/selinux-ucspitcp )"

PATCHES=(
	"${FILESDIR}"/${PV}-protos.patch
)

src_prepare() {
	if use ipv6 ; then
		PATCHES+=(
			"${WORKDIR}"/${P}-ipv6.diff20
			"${FILESDIR}"/${PV}-protos-ipv6.patch
			"${FILESDIR}"/${PV}-tcprules.patch #135571
			"${FILESDIR}"/${PV}-bigendian.patch #18892
			"${FILESDIR}"/${PV}-implicit-int-ipv6.patch
		)
	else
		PATCHES+=( "${FILESDIR}"/${PV}-protos-no-ipv6.patch )
	fi
	PATCHES+=(
		"${DISTDIR}"/ucspi-rss.diff
		"${FILESDIR}"/${PV}-rblsmtpd-ignore-on-RELAYCLIENT.patch
		"${DISTDIR}"/${P}-rblspp.patch
		"${FILESDIR}"/${PV}-protos-rblspp.patch
		"${FILESDIR}"/${PV}-large-responses.patch
		"${FILESDIR}"/${PV}-uint-headers.patch
		"${FILESDIR}"/${PV}-ar-ranlib.patch
		"${FILESDIR}"/${PV}-implicit-int.patch
		"${FILESDIR}"/${PV}-protype-alloc.patch
	)

	default
}

src_configure() {
	qmail_set_cc
	# The AR/RANLIB logic probably should get moved to the qmail eclass.
	# See also the patch above for generating the "makelib" script.
	tc-export AR RANLIB

	append-cflags $(test-flags-CC -std=gnu17)

	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc || die
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
