# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils qmake-utils systemd user readme.gentoo-r1

MY_P="mumble-${PV/_/~}"

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="http://mumble.sourceforge.net/"
SRC_URI="http://mumble.info/snapshot/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="+dbus debug +ice pch zeroconf"

RDEPEND=">=dev-libs/openssl-1.0.0b:0=
	>=dev-libs/protobuf-2.2.0
	sys-apps/lsb-release
	>=sys-libs/libcap-2.15
	dev-qt/qtcore:4[ssl]
	|| ( dev-qt/qtsql:4[sqlite] dev-qt/qtsql:4[mysql] )
	dev-qt/qtxmlpatterns:4
	dbus? ( dev-qt/qtdbus:4 )
	ice? ( dev-libs/Ice )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )"

DEPEND="${RDEPEND}
	>=dev-libs/boost-1.41.0
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.4-ice-3.5.0-compat.patch
	"${FILESDIR}"/${PN}-1.2.4-ice-3.5.1-compat.patch
)

DOC_CONTENTS="
	Useful scripts are located in /usr/share/doc/${PF}/scripts.\n
	Please execute:\n
	murmurd -ini /etc/murmur/murmur.ini -supw <pw>\n
	chown murmur:murmur /var/lib/murmur/murmur.sqlite\n
	to set the build-in 'SuperUser' password before starting murmur.
	Please restart dbus before starting murmur, or else dbus
	registration will fail.
"

pkg_setup() {
	enewgroup murmur
	enewuser murmur -1 -1 /var/lib/murmur murmur
}

src_prepare() {
	default

	sed \
		-e 's:mumble-server:murmur:g' \
		-e 's:/var/run:/run:g' \
		-i "${S}"/scripts/murmur.{conf,ini.system} || die
}

src_configure() {
	local conf_add

	use dbus || conf_add="${conf_add} no-dbus"
	use debug && conf_add="${conf_add} symbols debug" || conf_add="${conf_add} release"
	use ice || conf_add="${conf_add} no-ice"
	use pch || conf_add="${conf_add} no-pch"
	use zeroconf || conf_add="${conf_add} no-bonjour"

	eqmake4 main.pro -recursive \
		CONFIG+="${conf_add} no-client"
}

src_install() {
	dodoc README CHANGES

	docinto scripts
	dodoc scripts/*.php scripts/*.pl

	local dir
	if use debug; then
		dir=debug
	else
		dir=release
	fi

	dobin "${dir}"/murmurd

	insinto /etc/murmur/
	newins scripts/murmur.ini.system murmur.ini

	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/murmur.logrotate murmur

	insinto /etc/dbus-1/system.d/
	doins scripts/murmur.conf

	insinto /usr/share/murmur/
	doins src/murmur/Murmur.ice

	newinitd "${FILESDIR}"/murmur.initd-r1 murmur
	newconfd "${FILESDIR}"/murmur.confd murmur

	if use dbus; then
		systemd_newunit "${FILESDIR}"/murmurd-dbus.service "${PN}".service
		systemd_newtmpfilesd "${FILESDIR}"/murmurd-dbus.tmpfiles "${PN}".conf
	else
		systemd_newunit "${FILESDIR}"/murmurd-no-dbus.service "${PN}".service
	fi

	keepdir /var/lib/murmur /var/log/murmur
	fowners -R murmur /var/lib/murmur /var/log/murmur
	fperms 750 /var/lib/murmur /var/log/murmur

	# Fix permissions on config file as it might contain passwords.
	# (bug #559362)
	fowners root:murmur /etc/murmur/murmur.ini
	fperms 640 /etc/murmur/murmur.ini

	doman man/murmurd.1

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
