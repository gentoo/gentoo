# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="helper daemon to browse for remote CUPS queues and IPP network printers"
HOMEPAGE="https://github.com/OpenPrinting/cups-browsed"
SRC_URI="https://github.com/OpenPrinting/cups-browsed/releases/download/${PV}/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="ldap test zeroconf"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/glib:2
	>=net-print/cups-2
	>=net-print/cups-filters-2.0.0
	ldap? ( net-nds/openldap:= )
	test? ( net-print/cups[zeroconf] )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/0001-cups-browsed.c-Fix-build-with-avahi-disabled-20.patch
)

src_configure() {
	local myeconfargs=(
		--localstatedir="${EPREFIX}"/var
		--with-browseremoteprotocols=DNSSD,CUPS
		--with-cups-rundir="${EPREFIX}"/run/cups
		--with-rcdir=no

		$(use_enable ldap)
		$(use_enable zeroconf avahi)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	cp "${FILESDIR}"/cups-browsed.init.d "${T}"/cups-browsed || die

	if ! use zeroconf ; then
		sed -i -e 's:need cupsd avahi-daemon:need cupsd:g' "${T}"/cups-browsed || die
		sed -i -e 's:cups\.service avahi-daemon\.service:cups.service:g' "${S}"/daemon/cups-browsed.service || die
	fi

	doinitd "${T}"/cups-browsed
	systemd_dounit "${S}"/daemon/cups-browsed.service

}
