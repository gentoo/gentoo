# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 xdg pypi

DESCRIPTION="a personal document manager for scanned documents (and PDFs)"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork"

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
	dev-python/pyxdg[${PYTHON_USEDEP}]
	media-libs/libinsane
	x11-libs/libnotify[introspection]"
DEPEND="${RDEPEND}"

src_prepare() {
	# remove dep to allow both old python-Levenshtein and new
	# Levenshtein packages
	sed -i -e '/python-Levenshtein/d' setup.py || die
	distutils-r1_src_prepare
}

python_install_all() {
	distutils-r1_python_install_all

	# This queries tesseract languages and will fail sandbox with
	# USE=opencl, bugs #793446 #830012 #852134
	addpredict /dev/dri/renderD128
	addpredict /dev/kfd
	addpredict /dev/nvidiactl

	PYTHONPATH="src" "${EPYTHON}" src/paperwork_gtk/main.py install \
		--icon_base_dir="${ED}"/usr/share/icons \
		--data_base_dir="${ED}"/usr/share
}
