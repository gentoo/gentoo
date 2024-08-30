# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="ACS script compiler for use with ZDoom and Hexen"
HOMEPAGE="https://zdoom.org/wiki/ACC"
SRC_URI="https://github.com/ZDoom/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Activision"
SLOT="0"
KEYWORDS="~amd64"

# The Activision EULA is inappropriate but this was never resolved. :(
# https://doomwiki.org/wiki/Raven_source_code_licensing
RESTRICT="bindist mirror"

src_install() {
	dobin "${BUILD_DIR}"/${PN}
	dodoc readme.md

	insinto /usr/share/${PN}
	doins *.acs
}
