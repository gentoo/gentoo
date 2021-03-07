# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic systemd toolchain-funcs autotools

DESCRIPTION="powerful replacement for inetd"
HOMEPAGE="https://github.com/xinetd-org/xinetd https://github.com/openSUSE/xinetd"
SRC_URI="https://github.com/openSUSE/xinetd/releases/download/${PV}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="perl rpc selinux tcpd"

DEPEND="
	rpc? ( net-libs/libtirpc:= )
	selinux? ( sys-libs/libselinux )
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

PATCHES=(
	"${FILESDIR}"/${P}-no-rpc.patch #651838
	"${FILESDIR}"/${P}-rpc-configure.patch #651838
)

src_prepare() {
	default
	eautoreconf

	sed -i \
		-e 's:/usr/bin/kill:/bin/kill:' \
		"contrib/${PN}.service" || die
}

src_configure() {
	econf \
		$(use_with tcpd libwrap) \
		$(use_with selinux labeled-networking) \
		$(use_with rpc) \
		--with-loadavg
}

src_install() {
	default

	use perl || rm -f "${ED}"/usr/sbin/xconv.pl

	newinitd "${FILESDIR}"/xinetd.rc6 xinetd
	newconfd "${FILESDIR}"/xinetd.confd xinetd
	systemd_dounit "contrib/${PN}.service"

	newdoc contrib/xinetd.conf xinetd.conf.dist.sample
	dodoc README.md CHANGELOG
}
