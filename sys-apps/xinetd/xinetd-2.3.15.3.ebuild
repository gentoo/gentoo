# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic systemd toolchain-funcs

DESCRIPTION="powerful replacement for inetd"
HOMEPAGE="https://github.com/openSUSE/xinetd"
SRC_URI="${HOMEPAGE}/releases/download/${PV}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="perl rpc selinux tcpd"

DEPEND="
	selinux? ( sys-libs/libselinux )
	rpc? ( net-libs/libtirpc:= )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6-r2 )
"
RDEPEND="
	${DEPEND}
	perl? ( dev-lang/perl )
"
DEPEND="
	${DEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	find -name Makefile.in -exec sed -i 's:\<ar\>:$(AR):' {} +
}

src_configure() {
	tc-export AR PKG_CONFIG
	if use rpc ; then
		append-cflags $(${PKG_CONFIG} --cflags libtirpc)
	else
		append-cppflags -DNO_RPC
		export ac_cv_header_{rpc_{rpc,rpcent,pmap_clnt},netdb}_h=no
	fi
	LIBS=$(${PKG_CONFIG} --libs libtirpc) \
	econf \
		$(use_with tcpd libwrap) \
		$(use_with selinux labeled-networking) \
		--with-loadavg
}

src_install() {
	default

	use perl || rm -f "${ED}"/usr/sbin/xconv.pl

	newinitd "${FILESDIR}"/xinetd.rc6 xinetd
	newconfd "${FILESDIR}"/xinetd.confd xinetd
	systemd_dounit "${FILESDIR}/${PN}.service"

	newdoc contrib/xinetd.conf xinetd.conf.dist.sample
	dodoc README.md CHANGELOG
}
