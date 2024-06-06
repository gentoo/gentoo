# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-single-r1 xdg

DESCRIPTION="Actions gestures on your touchpad using libinput"
HOMEPAGE="https://github.com/bulletmark/libinput-gestures"
SRC_URI="https://github.com/bulletmark/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="experimental"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	dev-libs/libinput
	x11-misc/wmctrl
	x11-misc/xdotool"
DEPEND="dev-libs/libinput
	dev-util/desktop-file-utils"

src_prepare() {
	default

	use experimental && eapply "${FILESDIR}/${P}"-zombie.patch

	# Fix docdir installation path
	sed -i "/^DOCDIR/s@\$NAME@${PF}@" libinput-gestures-setup \
		|| die "sed failed for libinput-gestures-setup"
}

src_test() {
	emake test
}

src_install() {
	default
	# Actually respect the python target setting
	python_doscript "${PN}"
}

pkg_postinst() {
	xdg_icon_cache_update

	elog "You must be in the input group to read the touchpad device."

	if ! has_version x11-libs/gtk+:3 ; then
		elog "${PN}-setup script supports GNOME via x11-libs/gtk+:3."
	fi
	if ! has_version kde-plasma/kde-cli-tools:5 ; then
		elog "${PN}-setup script supports Plasma 5 via kde-plasma/kde-cli-tools:5."
	fi
}
