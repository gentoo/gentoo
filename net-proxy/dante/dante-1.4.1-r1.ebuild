# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools ltprune systemd user

DESCRIPTION="A free socks4,5 and msproxy implementation"
HOMEPAGE="https://www.inet.no/dante/"
SRC_URI="https://www.inet.no/dante/files/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug kerberos pam selinux static-libs tcpd upnp"

CDEPEND="
	kerberos? ( virtual/krb5 )
	pam? ( virtual/pam )
	tcpd? ( sys-apps/tcp-wrappers )
	upnp? ( net-libs/miniupnpc:= )
	userland_GNU? ( virtual/shadow )
"
DEPEND="${CDEPEND}
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-dante )
"

DOCS="BUGS CREDITS NEWS README SUPPORT doc/README* doc/*.txt doc/SOCKS4.protocol"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.0-socksify.patch
	"${FILESDIR}"/${PN}-1.4.0-osdep-format-macro.patch
	"${FILESDIR}"/${PN}-1.4.0-cflags.patch
	"${FILESDIR}"/${PN}-1.4.0-HAVE_SENDBUF_IOCTL.patch
	"${FILESDIR}"/${PN}-1.4.1-sigpwr-siginfo.patch #517528
	"${FILESDIR}"/${PN}-1.4.1-miniupnp14.patch #564680
)

src_prepare() {
	default

	sed -i \
		-e 's:/etc/socks\.conf:"${EPREFIX}"/etc/socks/socks.conf:' \
		-e 's:/etc/sockd\.conf:"${EPREFIX}"/etc/socks/sockd.conf:' \
		doc/{socksify.1,socks.conf.5,sockd.conf.5,sockd.8} \
		|| die

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die

	eautoreconf
}

src_configure() {
	# hardcoded the libc name otherwise the scan on a amd64 multilib system
	# ends up finding /usr/lib32/libc.so.5. That cascades and causes the
	# preload/libdsocks to not be built.
	econf \
		--with-socks-conf="${EPREFIX}"/etc/socks/socks.conf \
		--with-sockd-conf="${EPREFIX}"/etc/socks/sockd.conf \
		--enable-preload \
		--enable-clientdl \
		--enable-serverdl \
		--enable-drt-fallback \
		--with-libc=libc.so.6 \
		$(use_enable debug) \
		$(use_with kerberos gssapi) \
		$(use_with pam) \
		$(use_with upnp) \
		$(use_enable static-libs static) \
		$(use_with tcpd libwrap)
}

src_install() {
	default

	# default configuration files
	insinto /etc/socks
	doins "${FILESDIR}"/sock?.conf
	pushd "${ED}"/etc/socks > /dev/null
	use pam && eapply -p0 "${FILESDIR}"/sockd.conf-with-pam.patch
	use tcpd && eapply -p0 "${FILESDIR}"/sockd.conf-with-libwrap.patch
	popd > /dev/null

	# init script
	newinitd "${FILESDIR}"/${PN}-1.3.2-sockd-init dante-sockd
	newconfd "${FILESDIR}"/dante-sockd-conf dante-sockd

	systemd_dounit "${FILESDIR}"/dante-sockd.service

	# example configuration files
	docinto examples
	dodoc example/*.conf

	prune_libtool_files
}

pkg_postinst() {
	enewuser sockd -1 -1 /etc/socks daemon
}
