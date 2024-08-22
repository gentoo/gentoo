# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="A generic touchscreen calibration program for X.Org"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xinput_calibrator https://gitlab.freedesktop.org/xorg/app/xinput-calibrator"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrandr
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

XORG_CONFIGURE_OPTIONS=(
	--with-gui=x11
)
