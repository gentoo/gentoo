# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Hyprland implementation of wayland-scanner, in and for C++"

HOMEPAGE="https://github.com/hyprwm/hyprwayland-scanner/"

inherit cmake
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/hyprwm/hyprwayland-scanner.git"
	inherit git-r3
else
	SRC_URI="https://github.com/hyprwm/hyprwayland-scanner/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"

fi

LICENSE="BSD"

SLOT="0"

RDEPEND=">=dev-libs/pugixml-1.14"
DEPEND="${RDEPEND}"
