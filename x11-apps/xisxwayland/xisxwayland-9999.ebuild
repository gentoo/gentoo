# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
XORG_TARBALL_SUFFIX="xz"

inherit xorg-3 meson

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="amd64 ~loong"
fi

DESCRIPTION="Tool to determine whether the X server in use is Xwayland"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

# Override xorg-3's src_prepare
src_prepare() {
	default
}
