# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 xdg

DESCRIPTION="a personal document manager for scanned documents (and PDFs)"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="~app-text/openpaperwork-core-${PV}[${PYTHON_USEDEP}]
	~app-text/openpaperwork-gtk-${PV}[${PYTHON_USEDEP}]
	~app-text/paperwork-backend-${PV}[${PYTHON_USEDEP}]
	dev-python/libpillowfight[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/pyocr-0.3.0[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/simplebayes[${PYTHON_USEDEP}]
	media-libs/libinsane
	x11-libs/libnotify[introspection]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-desktop_file.patch )

python_install_all() {
	distutils-r1_python_install_all

	# This queries tesseract languages and will fail sandbox with
	# USE=opencl, bug #793446
	addpredict /dev/nvidiactl

	PYTHONPATH="src" "${EPYTHON}" src/paperwork_gtk/main.py install \
		--icon_base_dir="${ED}"/usr/share/icons \
		--data_base_dir="${ED}"/usr/share
}
