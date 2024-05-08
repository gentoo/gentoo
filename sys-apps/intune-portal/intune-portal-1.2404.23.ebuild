# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pam prefix systemd tmpfiles unpacker xdg

DESCRIPTION="Microsoft Intune Company Portal to access a corporate environment"
HOMEPAGE="https://learn.microsoft.com/mem/intune/"
SRC_URI="https://packages.microsoft.com/ubuntu/22.04/prod/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-jammy_amd64.deb"
S="${WORKDIR}"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

RDEPEND="
	app-accessibility/at-spi2-core:2
	app-crypt/libsecret
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/openssl:0/3
	net-libs/libsoup:2.4
	net-libs/webkit-gtk:4/37
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
	sys-libs/zlib
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
}

pkg_postinst() {
	touch "${EROOT}"/etc/pam.d/common-password || die
	tmpfiles_process intune.conf
	xdg_pkg_postinst
}
