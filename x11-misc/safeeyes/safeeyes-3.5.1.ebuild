# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="tk"  # for site-packages/Xlib/ext/randr.py
DISTUTILS_USE_PEP517=setuptools

inherit desktop xdg distutils-r1 pypi

DESCRIPTION="Linux alternative to EyeLeo"
HOMEPAGE="https://github.com/slgobinath/safeeyes"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	gui-libs/gtk:4[introspection]
	dev-libs/libayatana-appindicator
	dev-python/babel[${PYTHON_USEDEP}]
	dev-python/croniter[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
	media-sound/alsa-utils
	x11-apps/xprop
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	x11-misc/xprintidle
	"

python_install() {
	distutils-r1_python_install

	insinto /usr/share/icons/
	doins -r safeeyes/platform/icons/hicolor

	domenu safeeyes/platform/io.github.slgobinath.SafeEyes.desktop || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
