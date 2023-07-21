# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop optfeature xdg

DESCRIPTION="Official desktop client for Telegram (binary package)"
HOMEPAGE="https://desktop.telegram.org"
SRC_URI="
	https://github.com/telegramdesktop/tdesktop/archive/v${PV}.tar.gz -> tdesktop-${PV}.tar.gz
	amd64? ( https://updates.tdesktop.com/tlinux/tsetup.${PV}.tar.xz )
"

LICENSE="GPL-3-with-openssl-exception"
SLOT="0"
KEYWORDS="-* ~amd64"

QA_PREBUILT="usr/bin/telegram-desktop"

RDEPEND="
	!net-im/telegram-desktop
	sys-libs/glibc
	dev-libs/glib:2
	>=media-libs/fontconfig-2.13
	media-libs/freetype:2
	virtual/opengl
	x11-libs/libX11
	>=x11-libs/libxcb-1.10
"

S="${WORKDIR}/Telegram"

src_prepare() {
	default

	sed -i -e 's/^Exec=@CMAKE_INSTALL_FULL_BINDIR@\/telegram-desktop/Exec=\/usr\/bin\/telegram-desktop/' "${WORKDIR}/tdesktop-${PV}"/lib/xdg/org.telegram.desktop.service || die
}

src_install() {
	newbin Telegram telegram-desktop

	insinto /etc/tdesktop
	newins - externalupdater <<<"${EPREFIX}/usr/bin/telegram-desktop"

	local icon_size
	for icon_size in 16 32 48 64 128 256 512; do
		newicon -s "${icon_size}" \
			"${WORKDIR}/tdesktop-${PV}/Telegram/Resources/art/icon${icon_size}.png" \
			telegram.png
	done

	domenu "${WORKDIR}/tdesktop-${PV}"/lib/xdg/org.telegram.desktop.desktop
	insinto /usr/share/dbus-1/services
	doins "${WORKDIR}/tdesktop-${PV}"/lib/xdg/org.telegram.desktop.service
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "spell checker support" app-text/enchant
}
