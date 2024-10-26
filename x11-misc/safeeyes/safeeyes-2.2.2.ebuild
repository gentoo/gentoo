# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="tk"  # for site-packages/Xlib/ext/randr.py
DISTUTILS_USE_PEP517=setuptools

inherit xdg distutils-r1 pypi

DESCRIPTION="Linux alternative to EyeLeo"
HOMEPAGE="https://github.com/slgobinath/SafeEyes"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-libs/libayatana-appindicator
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/croniter[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
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

	# Workaround for https://bugs.gentoo.org/926816
	# Files were misplaced and also duplicate across Python slots.
	local misplaced_usr="${D}/usr/lib/${EPYTHON}/site-packages/usr"
	local i
	for i in applications icons ; do
		local source="${misplaced_usr}/share/${i}"
		local target="${D}/usr/share/${i}"
		if [[ ! -d "${target}" ]]; then
			dodir /usr/share/
			mv "${source}" "${target}" || die
		fi
	done
	rm -R "${misplaced_usr}" || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
