# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A virtual MIDI keyboard for X"
HOMEPAGE="https://github.com/tiwai/vkeybd"
SRC_URI="https://github.com/tiwai/vkeybd/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE="alsa lash oss"

RDEPEND="
	>=dev-lang/tk-8.3:=
	x11-libs/libX11
	alsa? ( media-libs/alsa-lib:= )
	lash? ( media-sound/lash:= )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.18c-desktop_entry.patch
	"${FILESDIR}"/${PN}-0.1.18c-fix-buildsystem.patch
)

src_configure() {
	export TCL_VERSION="$(echo 'puts [info tclversion]' | tclsh)"

	export USE_ALSA=$(usex alsa 1 0)
	export USE_AWE=$(usex alsa $(usex oss 1 0) 1)
	export USE_MIDI=$(usex alsa $(usex oss 1 0) 1)
	export USE_LASH=$(usex lash 1 0)

	tc-export CC PKG_CONFIG
}

pkg_postinst() {
	elog "The system-wide keymap is locale-sensitive now. A file"
	elog "vkeybdmap-\$LANG is searched in prior. For example, /etc/vkeybdmap-de"
	elog "can be used for the german locale. See the localization guide:"
	elog
	elog "https://wiki.gentoo.org/wiki/Localization/Guide"
}
