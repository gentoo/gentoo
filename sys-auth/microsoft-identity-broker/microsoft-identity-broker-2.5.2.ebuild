# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop prefix systemd unpacker xdg

FAKE_OS="ubuntu-24.04"
DESCRIPTION="Microsoft Authentication Broker to access a corporate environment"
HOMEPAGE="https://learn.microsoft.com/intune/"
SRC_URI="https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/${PN:0:1}/${PN}/${PN}_${PV%_p*}-noble_amd64.deb"
S="${WORKDIR}"
LICENSE="microsoft-proprietary Apache-2.0 BSD-2 MIT"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

RDEPEND="
	app-accessibility/at-spi2-core:2
	app-crypt/libsecret
	app-crypt/p11-kit
	dev-libs/glib:2
	dev-libs/openssl:0/3
	net-libs/libsoup:3.0
	net-libs/webkit-gtk:4.1/0
	net-misc/curl
	sys-apps/bubblewrap
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/pango
	virtual/zlib
"

QA_PREBUILT="*"
DIR="/opt/microsoft/identity-broker"
DB="microsoft-identity-device-broker"

pkg_setup() {
	local pv
	for pv in ${REPLACING_VERSIONS}; do
		if ver_test ${pv} -lt 2.0.3; then
			ewarn "You are upgrading to an entirely new implementation. It is highly recommended"
			ewarn "to unregister this system before upgrading. After upgrading, run"
			ewarn "\`dsreg --cleanup\` and \`sudo dsreg --cleanup\` before registering again."
			break
		fi
	done
}

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	dobin usr/bin/dsreg
	doman usr/share/man/man1/dsreg.1

	exeinto "${DIR}"/bin
	newexe $(prefixify_ro "${FILESDIR}"/wrapper) ${PN}
	dosym ${PN} "${DIR}"/bin/${DB}

	exeinto "${DIR}"/libexec
	doexe "${DIR#/}"/bin/{${PN},${DB}}

	insinto /usr/share
	doins -r usr/share/dbus-1

	systemd_dounit usr/lib/systemd/system/${DB}.service

	# DOS line endings? Yes, Chewi lol'd too. ;)
	tr -d "\r" < usr/share/applications/${PN}.desktop | newmenu - ${PN}.desktop
	doicon -s 256 usr/share/icons/hicolor/256x256/apps/${PN}.png

	dodoc usr/share/doc/${PN}/CHANGELOG.md

	keepdir /etc/microsoft/identity-broker/{certs,private}
	fperms 0700 /etc/microsoft/identity-broker/{certs,private}

	insinto /etc/microsoft/identity-broker/etc
	newins "${FILESDIR}/lsb-release-${FAKE_OS}" lsb-release
	newins "${FILESDIR}/os-release-${FAKE_OS}" os-release
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "This version is designed for GNOME Keyring. To use it with KWallet, run:"
	elog "  busctl --user call org.freedesktop.secrets /org/freedesktop/secrets org.freedesktop.Secret.Service SetAlias so login /org/freedesktop/secrets/collection/kdewallet"
	elog "To undo this change, run:"
	elog "  busctl --user call org.freedesktop.secrets /org/freedesktop/secrets org.freedesktop.Secret.Service SetAlias so login /"
}
