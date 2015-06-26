# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/modemmanager/modemmanager-1.4.8.ebuild,v 1.4 2015/06/26 09:23:47 ago Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
VALA_USE_DEPEND="vapigen"

inherit gnome2 user readme.gentoo udev vala

DESCRIPTION="Modem and mobile broadband management libraries"
HOMEPAGE="http://cgit.freedesktop.org/ModemManager/ModemManager/"
SRC_URI="http://www.freedesktop.org/software/ModemManager/ModemManager-${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0/1" # subslot = dbus interface version, i.e. N in org.freedesktop.ModemManager${N}
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ppc64 ~sparc x86"
IUSE="+introspection mbim policykit +qmi qmi-newest vala"
REQUIRED_USE="
	qmi-newest? ( qmi )
	vala? ( introspection )
"

RDEPEND="
	>=dev-libs/glib-2.32:2
	virtual/libgudev:=
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
	mbim? ( >=net-libs/libmbim-1.10 )
	policykit? ( >=sys-auth/polkit-0.106[introspection] )
	qmi? ( >=net-libs/libqmi-1.12.4:= )
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

S="${WORKDIR}/ModemManager-${PV}"

src_prepare() {
	DOC_CONTENTS="If your USB modem shows up as a Flash drive when you plug it in,
		You should install sys-apps/usb_modeswitch which will automatically
		switch it over to USB modem mode whenever you plug it in.\n"

	if use policykit; then
		DOC_CONTENTS+="\nTo control your modem without needing to enter the root password,
			add your user account to the 'plugdev' group."
	fi

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-more-warnings \
		--with-udev-base-dir="$(get_udevdir)" \
		--disable-static \
		--with-dist-version=${PVR} \
		$(use_enable introspection) \
		$(use_with mbim) \
		$(use_with policykit polkit) \
		$(use_with qmi) \
		$(use_with qmi-newest newest-qmi-commands) \
		$(use_enable vala)
}

src_install() {
	gnome2_src_install

	# Allow users in plugdev group full control over their modem
	if use policykit; then
		insinto /usr/share/polkit-1/rules.d/
		doins "${FILESDIR}"/01-org.freedesktop.ModemManager1.rules
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst

	use policykit && enewgroup plugdev

	# The polkit rules file moved to /usr/share
	old_rules="${EROOT}etc/polkit-1/rules.d/01-org.freedesktop.ModemManager.rules"
	if [[ -f "${old_rules}" ]]; then
		case "$(md5sum ${old_rules})" in
		  c5ff02532cb1da2c7545c3069e5d0992* | 5c50f0dc603c0a56e2851a5ce9389335* )
			# Automatically delete the old rules.d file if the user did not change it
			elog
			elog "Removing old ${old_rules} ..."
			rm -f "${old_rules}" || eerror "Failed, please remove ${old_rules} manually"
			;;
		  * )
			elog "The ${old_rules}"
			elog "file moved to /usr/share/polkit-1/rules.d/ in >=modemmanager-0.5.2.0-r2"
			elog "If you edited ${old_rules}"
			elog "without changing its behavior, you may want to remove it."
			;;
		esac
	fi

	readme.gentoo_print_elog
}
