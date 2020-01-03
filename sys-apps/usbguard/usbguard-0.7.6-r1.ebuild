# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Daemon protecting your computer against BadUSB"
HOMEPAGE="https://github.com/USBGuard/usbguard"
SRC_URI="https://github.com/USBGuard/usbguard/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion dbus ldap policykit systemd"

REQUIRED_USE="policykit? ( dbus )"

CDEPEND="
	dev-libs/pegtl
	>=dev-libs/libsodium-0.4.5:=
	>=dev-libs/protobuf-2.5.0:=
	>=sys-cluster/libqb-0.16.0:=
	sys-devel/gcc:*[cxx]
	>=sys-libs/libcap-ng-0.7.0
	>=sys-libs/libseccomp-2.0.0
	>=sys-process/audit-2.7.7
	bash-completion? ( >=app-shells/bash-completion-2.0 )
	dbus? (
		>=dev-libs/dbus-glib-0.100
		dev-libs/glib:2
		sys-apps/dbus
		policykit? ( sys-auth/polkit[introspection] )
	)
	ldap? ( net-nds/openldap )
	systemd? ( sys-apps/systemd )
	"
RDEPEND="${CDEPEND}
	virtual/udev
	"
DEPEND="${CDEPEND}
	app-text/asciidoc
	dev-cpp/catch:1
	dbus? (
		dev-libs/libxml2
		dev-libs/libxslt
		dev-util/gdbus-codegen
	)
	"

src_configure() {
	local myargs=(
		$(use_with dbus)
		$(use_with ldap)
		$(use_with policykit polkit)
		$(use_enable systemd)
		--disable-dependency-tracking
	)

	econf "${myargs[@]}"
}

src_install() {
	default

	keepdir /var/lib/log/usbguard

	newinitd "${FILESDIR}"/${P}-usbguard.openrc usbguard
	use dbus && newinitd "${FILESDIR}"/${P}-usbguard-dbus.openrc usbguard-dbus
}

pkg_postinst() {
	ewarn
	ewarn 'BEFORE STARTING USBGUARD please be sure to create/generate'
	ewarn '                         a rules file at /etc/usbguard/rules.conf'
	ewarn '                         so that you do not'
	ewarn '                                            GET LOCKED OUT'
	ewarn "                         of this system (\"$(hostname)\")."
	ewarn
	ewarn 'This command may be of help:'
	ewarn '  sudo sh -c "usbguard generate-policy > /etc/usbguard/rules.conf"'
	ewarn
}
