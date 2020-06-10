# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_rs 2 '-')"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="iwd without dbus"
HOMEPAGE="https://github.com/dylanaraps/eiwd"
SRC_URI="https://github.com/dylanaraps/eiwd/releases/download/${MY_PV}/${MY_P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client +monitor ofono +system-ell wired"

DEPEND="system-ell? ( >=dev-libs/ell-0.31 )"
RDEPEND="${DEPEND}
	!net-wireless/iwd
	net-wireless/wireless-regdb"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/iwd --localstatedir="${EPREFIX}"/var
		--disable-dbus
		$(use_enable client)
		$(use_enable monitor)
		$(use_enable ofono)
		$(use_enable system-ell external-ell)
		$(use_enable wired)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	keepdir /var/lib/iwd
	newinitd "${FILESDIR}"/iwd.initd iwd
	insinto /etc/iwd/
	doins "${FILESDIR}"/main.conf
}

pkg_postinst() {
	elog "To use eiwd's built-in DNS features you also need net-dns/openresolv"
	elog "or net-misc/dhcpcd."
}
