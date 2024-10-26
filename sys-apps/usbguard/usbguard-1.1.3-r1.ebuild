# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1

DESCRIPTION="Daemon protecting your computer against BadUSB"
HOMEPAGE="https://github.com/USBGuard/usbguard"
SRC_URI="https://github.com/USBGuard/usbguard/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/1"  # due to libusbguard.so.<1>.0.0
KEYWORDS="amd64 ~x86"
IUSE="dbus ldap policykit selinux static-libs systemd test umockdev"

# https://github.com/USBGuard/usbguard/issues/449
# https://bugs.gentoo.org/769692
REQUIRED_USE+=" test? ( static-libs )"

CDEPEND="
	dev-libs/pegtl
	>=dev-libs/libsodium-0.4.5:=
	>=dev-libs/protobuf-2.5.0:=
	>=sys-cluster/libqb-0.16.0:=
	sys-devel/gcc:*[cxx]
	>=sys-libs/libcap-ng-0.7.0
	>=sys-libs/libseccomp-2.0.0
	>=sys-process/audit-2.7.7
	dbus? (
		dev-libs/glib:2
		sys-apps/dbus
		sys-auth/polkit[introspection]
	)
	ldap? ( net-nds/openldap:= )
	systemd? ( sys-apps/systemd )
	umockdev? ( dev-util/umockdev )
	"
RDEPEND="${CDEPEND}
	virtual/udev
	selinux? ( sec-policy/selinux-usbguard )
	"
DEPEND="${CDEPEND}
	app-text/asciidoc
	<dev-cpp/catch-3:0
	dbus? (
		dev-libs/libxml2
		dev-libs/libxslt
		dev-util/gdbus-codegen
	)
	"

RESTRICT="!test? ( test )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myargs=(
		--with-bash-completion-dir=$(get_bashcompdir)
		--localstatedir=/var  # i.e. not /var/lib, bug 852296
		$(use_with dbus)
		$(use_with dbus polkit)
		$(use_with ldap)
		$(use_enable static-libs static)
		$(use_enable systemd)
		$(use_enable umockdev)
	)

	econf "${myargs[@]}"
}

src_install() {
	default

	keepdir /etc/usbguard/IPCAccessControl.d  # bug 808801
	keepdir /etc/usbguard/rules.d  # bug 933878
	keepdir /var/log/usbguard
	chmod 0600 "${ED}"/etc/usbguard/IPCAccessControl.d/.keep* || die  # bug 808801
	chmod 0600 "${ED}"/etc/usbguard/rules.d/.keep* || die  # bug 933878

	newinitd "${FILESDIR}"/${PN}-0.7.6-usbguard.openrc usbguard
	use dbus && newinitd "${FILESDIR}"/${PN}-0.7.6-usbguard-dbus.openrc usbguard-dbus

	find "${D}" -name '*.la' -delete || die  # bug 850655
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
