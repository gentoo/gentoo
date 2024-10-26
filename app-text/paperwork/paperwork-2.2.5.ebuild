# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 xdg

DESCRIPTION="a personal document manager for scanned documents (and PDFs)"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork"
# Update from release hash at:
# https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/tags
REL_HASH="620eb580"
SRC_URI="https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/archive/${PV}/paperwork-${PV}.tar.bz2
	https://download.openpaper.work/data/paperwork/master_${REL_HASH}/data.tar.gz -> paperwork-data-${PV}.tar.gz"
S=${WORKDIR}/paperwork-${PV}/${PN}-gtk

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="~app-text/openpaperwork-core-${PV}[${PYTHON_USEDEP}]
	~app-text/openpaperwork-gtk-${PV}[${PYTHON_USEDEP}]
	~app-text/paperwork-backend-${PV}[${PYTHON_USEDEP}]
	dev-python/libpillowfight[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/pyocr-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyxdg-0.25[${PYTHON_USEDEP}]
	media-libs/libinsane
	x11-libs/libnotify[introspection]"
DEPEND="${RDEPEND}"
BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]
	sys-apps/which
	sys-devel/gettext"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_prepare() {
	default
	cp -a "${WORKDIR}"/${PN}-gtk "${WORKDIR}"/paperwork-${PV}/
}

python_compile() {
	emake l10n_compile

	distutils-r1_python_compile
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
