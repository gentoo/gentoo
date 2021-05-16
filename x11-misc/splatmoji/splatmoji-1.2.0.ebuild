# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="Quickly look up and input emoji and/or emoticons"
HOMEPAGE="https://github.com/cspeterson/splatmoji/"
SRC_URI="https://github.com/cspeterson/splatmoji/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="test? (
		app-misc/jq
		dev-util/shunit2
	)"
RDEPEND="
	app-shells/bash
	x11-misc/rofi
	x11-misc/xdotool
	x11-misc/xsel"

src_test() {
	./test/unit_tests || die
}

src_install() {
	dobin splatmoji

	insinto /etc/xdg/splatmoji
	doins splatmoji.config

	insinto /usr/share/splatmoji
	doins -r data

	insinto /usr/lib/splatmoji
	doins lib/functions
}

pkg_postinst() {
	optfeature "JSON-style output" app-misc/jq
}
