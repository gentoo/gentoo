# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Generic command-line automation tool (no X!)"
HOMEPAGE="https://github.com/ReimuNotMoe/ydotool"
SRC_URI="https://github.com/ReimuNotMoe/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="
	app-text/scdoc
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-openrc.patch )
