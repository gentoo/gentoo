# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs flag-o-matic user systemd

DESCRIPTION="Small forwarding DNS server"
HOMEPAGE="http://www.thekelleys.org.uk/dnsmasq/doc.html"
SRC_URI="http://www.thekelleys.org.uk/dnsmasq/${P}.tar.xz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="auth-dns conntrack dbus +dhcp dhcp-tools dnssec idn +inotify ipv6 lua nls script selinux static tftp"
DM_LINGUAS="de es fi fr id it no pl pt_BR ro"
for dm_lingua in ${DM_LINGUAS}; do
	IUSE+=" linguas_${dm_lingua}"
done

CDEPEND="dbus? ( sys-apps/dbus )
	idn? ( net-dns/libidn )
	lua? ( dev-lang/lua:* )
	conntrack? ( net-libs/libnetfilter_conntrack )
	nls? (
		sys-devel/gettext
		net-dns/libidn
	)
"

DEPEND="${CDEPEND}
	app-arch/xz-utils
	dnssec? (
		dev-libs/nettle[gmp]
		static? (
			dev-libs/nettle[static-libs(+)]
		)
	)
	virtual/pkgconfig"

RDEPEND="${CDEPEND}
	dnssec? (
		!static? (
			dev-libs/nettle[gmp]
		)
	)
	selinux? ( sec-policy/selinux-dnsmasq )
"

REQUIRED_USE="dhcp-tools? ( dhcp )
	lua? ( script )"

use_have() {
	local useflag no_only uword
	if [[ $1 == '-n' ]]; then
		no_only=1
		shift
	fi
	useflag="${1}"
	shift

	uword="${1:-${useflag}}"
	shift

	while [[ ${uword} ]]; do
		uword="${uword^^}"

		if ! use "${useflag}"; then
			echo -n " -DNO_${uword}"
		elif [[ -z "${no_only}" ]]; then
			echo -n " -DHAVE_${uword}"
		fi
		uword="${1}"
		shift
	done
}

pkg_pretend() {
	if use static; then
		einfo "Only sys-libs/gmp and dev-libs/nettle are statically linked."
		use dnssec || einfo "Thus, ${P}[!dnssec,static] makes no sense; the static USE flag is ignored."
	fi
}

pkg_setup() {
	enewgroup dnsmasq
	enewuser dnsmasq -1 -1 /dev/null dnsmasq
}

src_prepare() {
	default

	sed -i -r 's:lua5.[0-9]+:lua:' Makefile
	sed -i "s:%%PREFIX%%:${EPREFIX}/usr:" dnsmasq.conf.example
}

src_configure() {
	COPTS="$(use_have -n auth-dns auth)"
	COPTS+="$(use_have conntrack)"
	COPTS+="$(use_have dbus)"
	COPTS+="$(use_have idn)"
	COPTS+="$(use_have -n inotify)"
	COPTS+="$(use_have -n dhcp dhcp dhcp6)"
	COPTS+="$(use_have -n ipv6 ipv6 dhcp6)"
	COPTS+="$(use_have lua luascript)"
	COPTS+="$(use_have -n script)"
	COPTS+="$(use_have -n tftp)"
	COPTS+="$(use_have dnssec)"
	COPTS+="$(use_have static dnssec_static)"
}

src_compile() {
	emake \
		PREFIX=/usr \
		MANDIR=/usr/share/man \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		COPTS="${COPTS}" \
		CONFFILE="/etc/${PN}.conf" \
		all$(use nls && echo "-i18n")

	use dhcp-tools && emake -C contrib/lease-tools \
		PREFIX=/usr \
		MANDIR=/usr/share/man \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		all
}

src_install() {
	local lingua puid
	emake \
		PREFIX=/usr \
		MANDIR=/usr/share/man \
		COPTS="${COPTS}" \
		DESTDIR="${D}" \
		install$(use nls && echo "-i18n")

	for lingua in ${DM_LINGUAS}; do
		use linguas_${lingua} || rm -rf "${D}"/usr/share/locale/${lingua}
	done
	[[ -d "${D}"/usr/share/locale/ ]] && rmdir --ignore-fail-on-non-empty "${D}"/usr/share/locale/

	dodoc CHANGELOG CHANGELOG.archive FAQ dnsmasq.conf.example
	dodoc -r logo

	docinto html/
	dodoc *.html

	newinitd "${FILESDIR}"/dnsmasq-init-r2 ${PN}
	newconfd "${FILESDIR}"/dnsmasq.confd-r1 ${PN}

	insinto /etc
	newins dnsmasq.conf.example dnsmasq.conf

	insinto /usr/share/dnsmasq
	doins trust-anchors.conf

	if use dhcp; then
		dodir /var/lib/misc
		newinitd "${FILESDIR}"/dnsmasq-init-dhcp-r1 ${PN}
	fi
	if use dbus; then
		insinto /etc/dbus-1/system.d
		doins dbus/dnsmasq.conf
	fi

	if use dhcp-tools; then
		dosbin contrib/lease-tools/{dhcp_release,dhcp_lease_time}
		doman contrib/lease-tools/{dhcp_release,dhcp_lease_time}.1
	fi

	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service
}

pkg_preinst() {
	# temporary workaround to (hopefully) prevent leases file from being removed
	[[ -f /var/lib/misc/dnsmasq.leases ]] && cp /var/lib/misc/dnsmasq.leases "${T}"
}

pkg_postinst() {
	# temporary workaround to (hopefully) prevent leases file from being removed
	[[ -f "${T}"/dnsmasq.leases ]] && cp "${T}"/dnsmasq.leases /var/lib/misc/dnsmasq.leases
}
