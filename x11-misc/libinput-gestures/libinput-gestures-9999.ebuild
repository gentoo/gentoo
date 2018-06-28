# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit git-r3 python-single-r1

DESCRIPTION="Actions gestures on your touchpad using libinput"
HOMEPAGE="https://github.com/bulletmark/libinput-gestures"
EGIT_REPO_URI="https://github.com/bulletmark/${PN}.git"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/libinput-1.8.0
	x11-misc/xdotool
	x11-misc/wmctrl"
DEPEND=">=dev-libs/libinput-1.8.0
	dev-util/desktop-file-utils
	test? ( dev-python/flake8[${PYTHON_USEDEP}] )"

pkg_postinst() {
	elog "You must be in the input group to read the touchpad device."

	if ! has_version x11-libs/gtk+:3 ; then
		elog "${PN}-setup script supports Gnome 3 via x11-libs/gtk+:3."
	fi
	if ! has_version kde-plasma/kde-cli-tools:5 ; then
		elog "${PN}-setup script supports Plasma 5 via kde-plasma/kde-cli-tools:5."
	fi
}
