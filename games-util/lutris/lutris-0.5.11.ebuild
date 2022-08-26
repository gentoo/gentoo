# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="sqlite,threads(+)"
DISTUTILS_SINGLE_IMPL="1"

inherit distutils-r1 optfeature virtualx xdg

DESCRIPTION="An open source gaming platform for GNU/Linux"
HOMEPAGE="https://lutris.net/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/lutris/lutris.git"
	inherit git-r3
else
	if [[ ${PV} == *_beta* ]] ; then
		SRC_URI="https://github.com/lutris/lutris/archive/refs/tags/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}"/${P/_/-}
	else
		SRC_URI="https://lutris.net/releases/${P/-/_}.tar.xz"
		S="${WORKDIR}/${PN}"
		KEYWORDS="~amd64 ~x86"
	fi
fi

LICENSE="GPL-3+ CC0-1.0"
SLOT="0"

RDEPEND="
	app-arch/cabextract
	app-arch/p7zip
	app-arch/unzip
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/python-evdev[${PYTHON_USEDEP}]
		dev-python/python-magic[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
	gnome-base/gnome-desktop:3[introspection]
	media-sound/fluid-soundfont
	net-libs/libsoup
	net-libs/webkit-gtk:4[introspection]
	x11-apps/mesa-progs
	x11-apps/xgamma
	x11-apps/xrandr
	x11-libs/gtk+:3[introspection]
	x11-libs/gdk-pixbuf[jpeg]
	x11-libs/libnotify[introspection]
"

distutils_enable_tests pytest

DOCS=( AUTHORS README.rst docs/installers.rst docs/steam.rst )

python_test() {
	virtx epytest
}

python_install_all() {
	distutils-r1_python_install_all
	python_fix_shebang "${ED}/usr/share/lutris/bin/lutris-wrapper" #740048
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "running windows games through wine+DXVK/proton or other Vulkan games (plus ICD for your hardware)" media-libs/vulkan-loader

	# Quote README.rst
	elog ""
	elog "Lutris installations are fully automated through scripts, which can"
	elog "be written in either JSON or YAML. The scripting syntax is described"
	elog "in ${EROOT}/usr/share/doc/${PF}/installers.rst.bz2, and is also"
	elog "available online at lutris.net."
}
