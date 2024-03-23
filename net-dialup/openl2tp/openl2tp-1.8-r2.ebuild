# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="Userspace tools for kernel L2TP implementation"
HOMEPAGE="https://sourceforge.net/projects/openl2tp/"
SRC_URI="mirror://sourceforge/openl2tp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client debug dmalloc doc +examples rpc server stats"

REQUIRED_USE="|| ( client server )"

BDEPEND="
	>=net-libs/rpcsvc-proto-1.3.1-r1
	app-alternatives/yacc
	app-alternatives/lex
"
DEPEND="
	>=net-dialup/ppp-2.4.5
	>=net-libs/libtirpc-1.0.3
	sys-libs/readline:=
	dmalloc? ( dev-libs/dmalloc )
"
RDEPEND="${DEPEND}
	rpc? ( net-nds/rpcbind )
"

CONFIG_CHECK="~PPPOL2TP"

PATCHES=(
	"${FILESDIR}/${P}-werror.patch"
	"${FILESDIR}/${P}-ldflags.patch"
	"${FILESDIR}/${P}-pppd-2.patch"
	"${FILESDIR}/${P}-man.patch"
	"${FILESDIR}/${P}-l2tpconfig.patch"
	"${FILESDIR}/${P}-parallelbuild.patch"
	"${FILESDIR}/${P}-optionsfile.patch"
	"${FILESDIR}/${P}-clientip_as_ipparam.patch"
	"${FILESDIR}/${P}-setkey.patch"
	"${FILESDIR}/${P}-unused-var.patch"
	"${FILESDIR}/${P}-configure-Makefile.patch"
	"${FILESDIR}/${P}-cflags.patch"
	"${FILESDIR}/${P}-tirpc.patch"
	"${FILESDIR}/${P}-native-tc.patch"
	"${FILESDIR}/${P}-musl.patch"
	"${FILESDIR}/${P}-strings.patch"
)

src_prepare() {
	default
	sed -i 's/CFLAGS.optimize/CFLAGS_optimize/g' Makefile */Makefile || die "Makefile sed failed"
}

src_configure() {
	myconf=

	use client	|| myconf+=" L2TP_FEATURE_LAC_SUPPORT=n
							 L2TP_FEATURE_LAIC_SUPPORT=n
							 L2TP_FEATURE_LAOC_SUPPORT=n "

	use server	|| myconf+=" L2TP_FEATURE_LNS_SUPPORT=n
							 L2TP_FEATURE_LNIC_SUPPORT=n
							 L2TP_FEATURE_LNOC_SUPPORT=n "

	use rpc		|| myconf+=" L2TP_FEATURE_RPC_MANAGEMENT=n "

	use stats	&& myconf+=" L2TP_FEATURE_LOCAL_STAT_FILE=y "
	use debug	&& myconf+=" L2TP_DEBUG=y "
	use dmalloc	&& myconf+=" USE_DMALLOC=y "

	echo ${myconf} > "${T}/myconf"
}

src_compile() {
	emake $(cat "${T}/myconf")
}

src_install() {
	emake $(cat "${T}/myconf") DESTDIR="${D}" install

	if use examples; then
		docinto event_socket
		dodoc doc/{event_sock_example.c,README.event_sock}
		docinto
		dodoc -r "${FILESDIR}"/examples
	fi

	if use doc; then
		dodoc doc/*.txt
		newdoc plugins/README README.plugins
		dodoc -r ipsec
	fi

	newinitd "${FILESDIR}"/openl2tpd.initd openl2tpd
	# init.d script is quite different for RPC and non-RPC versions.
	use rpc || sed -i s/userpc=\"yes\"/userpc=\"no\"/ "${D}/etc/init.d/openl2tpd" || die "sed failed"
	newconfd "${FILESDIR}"/openl2tpd.confd openl2tpd
}

pkg_postinst() {
	if use rpc; then
		ewarn
		ewarn "RPC control does not provide any auth checks for control connection."
		ewarn "Unless you need this you should disable it, for reference:"
		ewarn "http://forums.openl2tp.org/viewtopic.php?f=4&t=41"
		ewarn
		ewarn "Therefore DO NOT USE RPC IN INSECURE ENVIRONMENTS!"
	else
		ewarn
		ewarn "Without RPC support you won't be able to use l2tpconfig."
		ewarn "Please read http://forums.openl2tp.org/viewtopic.php?f=4&t=41"
		ewarn "for more information about the security risk before enabling."
		ewarn
		ewarn "If you are using numerical strings (e.g. login name containing only"
		ewarn "digits) or special characters in password, please use double quotes"
		ewarn "to enclose them."
	fi
	if use stats; then
		ewarn
		ewarn "To enable status files openl2tpd must be started with -S option."
		ewarn "Upstream warns about runtime overhead with status files enabled."
	fi
}
