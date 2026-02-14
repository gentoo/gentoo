# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pam prefix readme.gentoo-r1 systemd tmpfiles unpacker xdg

DESCRIPTION="Microsoft Intune Company Portal to access a corporate environment"
HOMEPAGE="https://learn.microsoft.com/mem/intune/"
SRC_URI="https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-noble_amd64.deb"
S="${WORKDIR}"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

RDEPEND="
	app-accessibility/at-spi2-core:2
	app-crypt/libsecret
	app-crypt/p11-kit
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/openssl:0/3
	net-libs/libsoup:3.0
	net-libs/webkit-gtk:4.1/0
	net-misc/curl
	sys-apps/bubblewrap
	sys-apps/dbus
	sys-apps/lsb-release
	sys-apps/systemd
	sys-apps/util-linux
	sys-auth/microsoft-identity-broker
	sys-auth/pambase[pwquality]
	sys-auth/polkit
	sys-libs/pam
	virtual/zlib:=
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/pango

	|| (
		www-client/microsoft-edge
		www-client/microsoft-edge-beta
		www-client/microsoft-edge-dev
	)
"

QA_PREBUILT="*"
DIR="/opt/microsoft/intune"

DOC_CONTENTS="You should manually add an \"optional pam_intune.so\" line to the bottom of the auth, password, and \
session entries in /etc/pam.d/system-auth. You may need to tailor this to your own PAM configuration."

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	exeinto "${DIR}"/bin
	newexe $(prefixify_ro "${FILESDIR}"/wrapper) intune-portal
	dosym intune-portal /opt/microsoft/intune/bin/intune-agent
	dosym intune-portal /opt/microsoft/intune/bin/intune-daemon

	exeinto "${DIR}"/libexec
	doexe "${DIR#/}"/bin/*

	insinto "${DIR}"/share
	doins -r "${DIR#/}"/share/*

	insinto /usr/share/polkit-1/actions
	doins usr/share/polkit-1/actions/com.microsoft.intune.policy

	systemd_dounit lib/systemd/system/*
	systemd_douserunit lib/systemd/user/*

	dopammod usr/lib/x86_64-linux-gnu/security/pam_intune.so
	dotmpfiles usr/lib/tmpfiles.d/intune.conf

	domenu usr/share/applications/*.desktop
	doicon -s 48 usr/share/icons/hicolor/48x48/*/*.png

	readme.gentoo_create_doc
}

pkg_postinst() {
	touch "${EROOT}"/etc/pam.d/common-password || die
	tmpfiles_process intune.conf
	xdg_pkg_postinst
	readme.gentoo_print_elog
}
