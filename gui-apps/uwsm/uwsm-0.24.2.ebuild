# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
inherit meson optfeature python-single-r1

DESCRIPTION="Universal Wayland Session Manager"
HOMEPAGE="https://github.com/Vladimir-csp/uwsm"
SRC_URI="https://github.com/Vladimir-csp/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+man"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
	')
"
RDEPEND="${DEPEND}"
BDEPEND="man? ( app-text/scdoc )"

src_configure() {
	local emesonargs=(
		-Duuctl=enabled
		-Dfumon=enabled
		-Duwsm-app=enabled
		$(meson_feature man man-pages)
		-Ddocdir=/usr/share/doc/"${PF}"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}/usr/bin"
	python_optimize "${ED}/usr/share/${PN}"
}

pkg_postinst() {
	optfeature "TUI selection menu feature" dev-libs/newt
	optfeature "GUI selection menu for uuctl" gui-apps/wofi
	optfeature "GUI selection menu for uuctl" x11-misc/dmenu
	optfeature "GUI selection menu for uuctl" x11-misc/rofi
	optfeature "notifications from uwsm commands and services (notify-send)" x11-libs/libnotify
}
