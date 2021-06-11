# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Copyright 2020 Thomas Schneider <qsx@chaotikum.eu>

EAPI=7

inherit autotools prefix systemd

MY_PV="$(ver_cut 1)"
MY_DEB_PV="$(ver_cut 1)-$(ver_cut 3)"

DESCRIPTION="WIDE project DHCPv6 client and server"
HOMEPAGE="https://wide-dhcpv6.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/wide-dhcpv6/wide-dhcpv6-${MY_PV}.tar.gz
	mirror://debian/pool/main/w/wide-dhcpv6/wide-dhcpv6_${MY_DEB_PV}.debian.tar.xz
"
S="${WORKDIR}/wide-dhcpv6-${MY_PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

PATCHES=(
	"${WORKDIR}"/debian/patches
)

src_prepare() {
	default
	rm configure cfparse.c cftoken.c y.tab.h || die
	mv configure.{in,ac} || die
	eautoreconf

	cp "${FILESDIR}/wide-dhcp6c.init" . || die
	cp "${FILESDIR}/wide-dhcp6s.init" . || die
	hprefixify wide-dhcp6{c,s}.init
}

src_configure() {
	econf \
		--with-localdbdir="${EPREFIX}/var/lib/dhcpv6" \
		--sysconfdir="${EPREFIX}/etc/wide-dhcpv6"
}

src_install() {
	# make install doesn’t honor DESTDIR
	doman *.5 *.8
	dosbin dhcp6c dhcp6s dhcp6relay dhcp6ctl
	keepdir /var/lib/dhcpv6

	insinto /etc/wide-dhcpv6
	doins dhcp6c.conf.sample dhcp6s.conf.sample

	dodoc "${FILESDIR}/README.gentoo"
	einstalldocs

	systemd_newunit "${FILESDIR}/dhcp6c-AT.service" "dhcp6c@.service"
	systemd_newunit "${FILESDIR}/dhcp6s-AT.service" "dhcp6s@.service"
	newinitd wide-dhcp6c.init wide-dhcp6c
	newinitd wide-dhcp6s.init wide-dhcp6s
	newconfd "${FILESDIR}/wide-dhcp6c.conf" wide-dhcp6c
	newconfd "${FILESDIR}/wide-dhcp6s.conf" wide-dhcp6s
}

pkg_postinst() {
	elog "To control dhcp6c/dhcp6s with dhcp6ctl(8), you need to"
	elog "create a control key each, for example:"
	elog "umask 077 && \\"
	elog "openssl rand -base64 -out /etc/wide-dhcpv6/dhcp6cctlkey 32 && \\"
	elog "openssl rand -base64 -out /etc/wide-dhcpv6/dhcp6sctlkey 32"
}
