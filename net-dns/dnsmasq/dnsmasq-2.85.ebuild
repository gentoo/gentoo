# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit toolchain-funcs flag-o-matic lua-single systemd

DESCRIPTION="Small forwarding DNS server"
HOMEPAGE="https://thekelleys.org.uk/dnsmasq/doc.html"
SRC_URI="https://thekelleys.org.uk/dnsmasq/${P}.tar.xz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

IUSE="auth-dns conntrack dbus +dhcp dhcp-tools dnssec +dumpfile id idn libidn2"
IUSE+=" +inotify ipv6 lua nettlehash nls script selinux static tftp"

DM_LINGUAS=(de es fi fr id it no pl pt_BR ro)

BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

COMMON_DEPEND="
	acct-group/dnsmasq
	acct-user/dnsmasq
	dbus? ( sys-apps/dbus:= )
	idn? (
		!libidn2? ( net-dns/libidn:0= )
		libidn2? ( >=net-dns/libidn2-2.0:= )
	)
	lua? ( ${LUA_DEPS} )
	conntrack? ( net-libs/libnetfilter_conntrack:= )
	nls? ( sys-devel/gettext )
"

DEPEND="${COMMON_DEPEND}
	dnssec? (
		dev-libs/nettle:=[gmp]
		static? ( >=dev-libs/nettle-3.4[static-libs(+)] )
	)
"

RDEPEND="${COMMON_DEPEND}
	dnssec? (
		!static? ( >=dev-libs/nettle-3.4:=[gmp] )
	)
	selinux? ( sec-policy/selinux-dnsmasq )
"

REQUIRED_USE="
	dhcp-tools? ( dhcp )
	dnssec? ( !nettlehash )
	lua? (
		script
		${LUA_REQUIRED_USE}
	)
	libidn2? ( idn )
"

use_have() {
	local no_only
	if [[ ${1} == '-n' ]]; then
		no_only=1
		shift
	fi
	local useflag="${1}"
	shift

	local uword="${1:-${useflag}}"
	shift

	while [[ ${uword} ]]; do
		uword="${uword^^}"

		if ! use "${useflag}"; then
			printf -- " -DNO_%s" "${uword}"
		elif [[ -z "${no_only}" ]]; then
			printf -- " -DHAVE_%s" "${uword}"
		fi
		uword="${1}"
		shift
	done
}

pkg_setup() {
	use lua && lua-single_pkg_setup
}

pkg_pretend() {
	if use static; then
		einfo "Only sys-libs/gmp and dev-libs/nettle are statically linked."
		use dnssec || einfo "Thus, ${P}[!dnssec,static] makes no sense;" \
			"in this case the static USE flag does nothing."
	fi
}

src_prepare() {
	default

	sed -i -r 's:lua5.[0-9]+:lua:' Makefile || die
	sed -i "s:%%PREFIX%%:${EPREFIX}/usr:" \
		dnsmasq.conf.example || die
}

src_configure() {
	COPTS=(
		$(use_have -n auth-dns auth)
		$(use_have conntrack)
		$(use_have dbus)
		$(use libidn2 || use_have idn)
		$(use_have libidn2)
		$(use_have -n inotify)
		$(use_have -n dhcp dhcp dhcp6)
		$(use_have -n ipv6 ipv6 dhcp6)
		$(use_have -n id id)
		$(use_have lua luascript)
		$(use_have -n script)
		$(use_have -n tftp)
		$(use_have dnssec)
		$(use_have nettlehash)
		$(use_have static dnssec_static)
		$(use_have -n dumpfile)
	)
}

src_compile() {
	emake \
		PREFIX=/usr \
		MANDIR=/usr/share/man \
		CC="$(tc-getCC)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		COPTS="${COPTS[*]}" \
		CONFFILE="/etc/${PN}.conf" \
		all$(use nls && printf -- "-i18n\n")

	use dhcp-tools && emake -C contrib/lease-tools \
		PREFIX=/usr \
		MANDIR=/usr/share/man \
		CC="$(tc-getCC)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		all
}

src_install() {
	local lingua puid
	emake \
		PREFIX=/usr \
		MANDIR=/usr/share/man \
		COPTS="${COPTS[*]}" \
		DESTDIR="${ED}" \
		install$(use nls && printf -- "-i18n\n")

	for lingua in "${DM_LINGUAS[@]}"; do
		has ${lingua} ${LINGUAS-${lingua}} \
			|| rm -rf "${ED}"/usr/share/locale/${lingua}
	done
	[[ -d "${D}"/usr/share/locale/ ]] && \
		rmdir --ignore-fail-on-non-empty "${ED}"/usr/share/locale/

	dodoc CHANGELOG CHANGELOG.archive FAQ dnsmasq.conf.example
	dodoc -r logo

	docinto html/
	dodoc *.html

	newinitd "${FILESDIR}"/dnsmasq-init-r4 ${PN}
	newconfd "${FILESDIR}"/dnsmasq.confd-r1 ${PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/dnsmasq.logrotate ${PN}

	insinto /etc
	newins dnsmasq.conf.example dnsmasq.conf

	insinto /usr/share/dnsmasq
	doins trust-anchors.conf

	if use dhcp; then
		keepdir /var/lib/misc
		newinitd "${FILESDIR}"/dnsmasq-init-dhcp-r3 ${PN}
	fi
	if use dbus; then
		insinto /etc/dbus-1/system.d
		doins dbus/dnsmasq.conf
	fi

	if use dhcp-tools; then
		dosbin contrib/lease-tools/{dhcp_release,dhcp_lease_time}
		doman contrib/lease-tools/{dhcp_release,dhcp_lease_time}.1
		if use ipv6; then
			dosbin contrib/lease-tools/dhcp_release6
			doman contrib/lease-tools/dhcp_release6.1
		fi
	fi

	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service
}

pkg_preinst() {
	[[ -f /var/lib/misc/dnsmasq.leases ]] && \
		cp /var/lib/misc/dnsmasq.leases "${T}"
}

pkg_postinst() {
	[[ -f "${T}"/dnsmasq.leases ]] && \
		cp "${T}"/dnsmasq.leases /var/lib/misc/dnsmasq.leases
}
