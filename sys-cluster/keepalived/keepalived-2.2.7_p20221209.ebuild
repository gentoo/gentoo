# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd
GIT_COMMIT="fbd699fac85d768c3ddab048a8f9d3dfaec7eaad"

DESCRIPTION="A strong & robust keepalive facility to the Linux Virtual Server project"
HOMEPAGE="https://www.keepalived.org/"
SRC_URI="https://github.com/acassen/keepalived/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/keepalived-${GIT_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="+bfd dbus json regex snmp systemd"

RDEPEND="
	dev-libs/libnl:=
	dev-libs/openssl:=
	dev-libs/popt
	net-libs/libnfnetlink
	sys-apps/iproute2
	regex? ( >=dev-libs/libpcre2-8:= )
	dbus? (
		sys-apps/dbus
		dev-libs/glib:2
	)
	json? ( dev-libs/json-c:= )
	snmp? ( net-analyzer/net-snmp:= )
	systemd? ( sys-apps/systemd )"
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
	econf \
		--with-init="$(usex systemd systemd custom)" \
		--with-kernel-dir="${ESYSROOT}"/usr \
		--enable-vrrp \
		$(use_enable bfd) \
		$(use_enable dbus) \
		$(use_enable json) \
		$(use_enable regex) \
		$(use_enable snmp) \
		$(use_enable snmp snmp-rfc) \
		$(use_enable systemd)
}

src_install() {
	default

	newinitd "${FILESDIR}"/keepalived.init-r1 keepalived
	newconfd "${FILESDIR}"/keepalived.confd-r1 keepalived

	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service
	systemd_install_serviced "${FILESDIR}/${PN}.service.conf"

	use snmp && dodoc doc/*MIB.txt

	# This was badly named by upstream, it's more HOWTO than anything else.
	newdoc INSTALL INSTALL+HOWTO

	# Clean up sysvinit files
	rm -rv "${ED}"/etc/sysconfig || die
}
