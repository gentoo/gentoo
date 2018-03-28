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
IUSE="perl selinux tcpd"

DEPEND="
	selinux? ( sys-libs/libselinux )
	kernel_linux? ( net-libs/libtirpc:= )
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
