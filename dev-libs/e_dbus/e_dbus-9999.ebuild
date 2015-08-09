# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

if [[ ${PV} == "9999" ]] ; then
	EGIT_SUB_PROJECT="legacy"
	EGIT_URI_APPEND=${PN}
	EGIT_BRANCH=${PN}-1.7
else
	SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="Enlightenment's (Ecore) integration to DBus"

LICENSE="BSD-2"
IUSE="bluetooth +connman +libnotify ofono static-libs test-binaries +udev"

RDEPEND=">=dev-libs/efl-1.8.4
	sys-apps/dbus
	connman? ( >=net-misc/connman-0.75 )
	udev? ( || ( sys-power/upower sys-power/upower-pm-utils ) sys-fs/udisks:0 )
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${PV%%_*}

src_configure() {
	E_ECONF=(
		$(use_enable bluetooth ebluez)
		$(use_enable connman econnman0_7x)
		$(use_enable doc)
		--disable-ehal
		$(use_enable libnotify enotify)
		$(use_enable ofono eofono)
		$(use_enable test-binaries edbus-test)
		$(use_enable test-binaries edbus-test-client)
		$(use_enable udev eukit)
	)
	if use test-binaries ; then
		E_ECONF+=(
			$(use_enable bluetooth edbus-bluez-test)
			$(use_enable connman edbus-connman0_7x-test)
			$(use_enable libnotify edbus-notification-daemon-test)
			$(use_enable libnotify edbus-notify-test)
			$(use_enable ofono edbus-ofono-test)
			$(use_enable udev edbus-ukit-test)
		)
	else
		E_ECONF+=(
			 --disable-edbus-bluez-test
			--disable-edbus-connman0_7x-test
			--disable-edbus-notification-daemon-test
			--disable-edbus-notify-test
			--disable-edbus-ofono-test
			--disable-edbus-ukit-test
			--disable-edbus-async-test
			--disable-edbus-performance-test
		)
	fi
	enlightenment_src_configure
}
