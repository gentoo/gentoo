# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Quickly look up and input emoji and/or emoticons"
HOMEPAGE="https://github.com/cspeterson/splatmoji/"
SRC_URI="https://github.com/cspeterson/splatmoji/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	app-shells/bash
	x11-misc/rofi
	x11-misc/xdotool
	x11-misc/xsel"

src_install() {
	dobin splatmoji
	insinto /etc/xdg/splatmoji
	doins splatmoji.config
	insinto /usr/share/splatmoji
	doins -r data
	insinto /usr/lib/splatmoji
	doins lib/functions
}
