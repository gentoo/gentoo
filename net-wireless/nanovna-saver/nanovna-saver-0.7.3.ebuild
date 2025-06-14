# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=setuptools

PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 xdg-utils

DESCRIPTION="tool for reading, displaying and saving data from the NanoVNA"
HOMEPAGE="https://github.com/mihtjel/nanovna-saver"

LICENSE="GPL-3+"
SLOT="0"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mihtjel/nanovna-saver.git"
else
	SRC_URI="https://github.com/mihtjel/nanovna-saver/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="amd64"
	export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
fi

RDEPEND="${DEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pyside[${PYTHON_USEDEP},gui,tools,widgets]
	dev-python/scipy[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

# drop local build_backend which only calls ui_compile (see below) and
# uses setuptools.build_meta afterwards
PATCHES=( "${FILESDIR}"/${PN}-0.7.3-pyproject.patch
		"${FILESDIR}"/${PN}-0.7.3-TDR.patch )

python_prepare_all() {
	# convert .ui and .qrc files to .py
	python src/tools/ui_compile.py || die
	# remove no longer needed helper tools to avoid their installation
	rm -R src/tools -R || die

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
