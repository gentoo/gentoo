# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/app/${PN}.git"
fi

inherit ${GIT_ECLASS} meson

DESCRIPTION="Tool to determine whether the X server in use is Xwayland"
HOMEPAGE="https://gitlab.freedesktop.org/xorg/app/xisxwayland"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~amd64 ~loong"
	SRC_URI="https://xorg.freedesktop.org/archive/individual/app/${P}.tar.xz"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
