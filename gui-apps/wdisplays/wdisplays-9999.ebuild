# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]]
then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cyclopsian/wdisplays.git"
else
	SRC_URI="https://github.com/cyclopsian/wdisplays/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
inherit meson xdg

DESCRIPTION="GUI display configurator for wlroots compositors"
HOMEPAGE="https://cyclopsian.github.io/wdisplays https://github.com/cyclopsian/wdisplays"

RDEPEND="
	x11-libs/gtk+:3=[wayland]
	gui-libs/wlroots:="
DEPEND="${RDEPEND}"

LICENSE="GPL-3+"
SLOT="0"

PATCHES=( "${FILESDIR}/wdisplays-1.0-pull20.patch" )
