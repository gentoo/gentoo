# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="A strong & robust keepalive facility to the Linux Virtual Server project"
HOMEPAGE="https://www.keepalived.org/"
SRC_URI="https://www.keepalived.org/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="+bfd dbus debug -json regex snmp"

RDEPEND="dev-libs/libnl:=
	dev-libs/openssl:=
	dev-libs/popt
	net-libs/libnfnetlink
	sys-apps/iproute2
	regex? ( >=dev-libs/libpcre2-8 )
	dbus? ( sys-apps/dbus dev-libs/glib:2 )
	json? ( dev-libs/json-c:= )
	snmp? ( net-analyzer/net-snmp )"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-4.4"

DOCS=(
	README CONTRIBUTORS INSTALL ChangeLog AUTHOR TODO
	doc/keepalived.conf.SYNOPSIS doc/NOTE_vrrp_vmac.txt
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# keepalived has support to dynamically use some libraries instead of
	# linking them:
	#--enable-dynamic-linking \
	#--enable-libiptc-dynamic \
	#--enable-libnl-dynamic \
	#--enable-libxtables-dynamic \
	STRIP=/bin/true \
	econf \
		--with-init=custom \
		--with-kernel-dir=/usr \
		--enable-sha1 \
		--enable-vrrp \
		$(use_enable bfd) \
		$(use_enable dbus) \
		$(use_enable dbus dbus-create-instance) \
		$(use_enable debug) \
		$(use_enable json) \
		$(use_enable regex) \
		$(use_enable regex regex-timers ) \
		$(use_enable snmp) \
		$(use_enable snmp snmp-checker) \
		$(use_enable snmp snmp-rfc) \
		$(use_enable snmp snmp-rfcv2) \
		$(use_enable snmp snmp-rfcv3) \
		$(use_enable snmp snmp-vrrp)
}

src_install() {
	default

	newinitd "${FILESDIR}"/keepalived.init-r1 keepalived
	newconfd "${FILESDIR}"/keepalived.confd-r1 keepalived

	systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service
	systemd_install_serviced "${FILESDIR}/${PN}.service.conf"

	use snmp && dodoc doc/*MIB.txt

	docinto genhash
	dodoc genhash/README genhash/AUTHOR genhash/ChangeLog
	# This was badly named by upstream, it's more HOWTO than anything else.
	newdoc INSTALL INSTALL+HOWTO

	# Security risk to bundle SSL certs
	rm -v "${ED}"/etc/keepalived/samples/*.pem || die
	# Clean up sysvinit files
	rm -rv "${ED}"/etc/sysconfig || die
}
