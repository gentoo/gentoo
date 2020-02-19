# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit eutils distutils-r1 virtualx xdg-utils

# Commit of documentation to fetch
DOCS_PV="6177401"

DESCRIPTION="The Scientific Python Development Environment"
HOMEPAGE="
	https://www.spyder-ide.org/
	https://github.com/spyder-ide/spyder/
	https://pypi.org/project/spyder/"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/spyder-ide/${PN}-docs/archive/${DOCS_PV}.tar.gz -> ${P}-docs.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/atomicwrites[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.0.0[${PYTHON_USEDEP}]
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/diff-match-patch[${PYTHON_USEDEP}]
	dev-python/intervaltree[${PYTHON_USEDEP}]
	~dev-python/jedi-0.14.1[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/nbconvert[${PYTHON_USEDEP}]
	dev-python/numpydoc[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pickleshare[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	dev-python/pylint[${PYTHON_USEDEP}]
	>=dev-python/python-language-server-0.31.2[${PYTHON_USEDEP}]
	>=dev-python/pyxdg-0.26[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	>=dev-python/qdarkstyle-2.7[${PYTHON_USEDEP}]
	>=dev-python/qtawesome-0.5.7[${PYTHON_USEDEP}]
	>=dev-python/qtconsole-4.6.0[${PYTHON_USEDEP}]
	>=dev-python/QtPy-1.5.0[${PYTHON_USEDEP},svg,webengine]
	dev-python/sphinx[${PYTHON_USEDEP}]
	>=dev-python/spyder-kernels-1.8.1[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/matplotlib[tk,${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pytest-lazy-fixture[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
	dev-python/pytest-qt[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}] )"

# Based on the courtesy of Arfrever
# This patch removes a call to update-desktop-database during build
# This fails because access is denied to this command during build
PATCHES=( "${FILESDIR}"/${P}-build.patch )

distutils_enable_tests pytest
distutils_enable_sphinx docs/doc --no-autodoc

python_prepare_all() {
	# move docs into workdir
	mv ../spyder-docs-${DOCS_PV}* docs || die

	# some tests still depend on QtPy[webkit] which is going to be removed
	# spyder itself works fine without webkit
	rm spyder/widgets/tests/test_browser.py || die
	rm spyder/plugins/onlinehelp/tests/test_pydocgui.py || die
	rm spyder/plugins/ipythonconsole/tests/test_ipythonconsole.py || die
	rm spyder/plugins/ipythonconsole/tests/test_ipython_config_dialog.py || die
	rm spyder/plugins/help/tests/test_widgets.py || die
	rm spyder/plugins/help/tests/test_plugin.py  || die
	rm spyder/app/tests/test_mainwindow.py || die

	# skip uri (online) tests
	rm spyder/plugins/editor/widgets/tests/test_goto.py || die

	# skip online test
	rm spyder/widgets/github/tests/test_github_backend.py || die

	# Assertion error, looks like an online test
	rm spyder/utils/tests/test_vcs.py || die

		# No idea why this fails, no error just stops and dumps core
	sed -i -e 's:test_arrayeditor_edit_complex_array:_&:' \
		spyder/plugins/variableexplorer/widgets/tests/test_arrayeditor.py || die

	# Assertion error, can't connect/remember inside ebuild environment
	sed -i -e 's:test_connection_dialog_remembers_input_with_password:_&:' \
		-e 's:test_connection_dialog_remembers_input_with_ssh_passphrase:_&:' \
			spyder/plugins/ipythonconsole/widgets/tests/test_kernelconnect.py || die

	# Assertion error (pytest-qt), maybe we can't do shortcuts inside ebuild environment?
	sed -i -e 's:test_transform_to_uppercase_shortcut:_&:' \
		-e 's:test_transform_to_lowercase_shortcut:_&:' \
		-e 's:test_go_to_line_shortcut:_&:' \
		-e 's:test_delete_line_shortcut:_&:' \
			spyder/plugins/editor/widgets/tests/test_shortcuts.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	virtx pytest -vv
}

python_install_all() {
	distutils-r1_python_install_all
	dosym spyder3 /usr/bin/spyder
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	elog "To get additional features, optional runtime dependencies may be installed:"
		optfeature "2D/3D plotting in the Python and IPython consoles" dev-python/matplotlib
		optfeature "View and edit DataFrames and Series in the Variable Explorer" dev-python/pandas
		optfeature "View and edit two or three dimensional arrays in the Variable Explorer" dev-python/numpy
		optfeature "Symbolic mathematics in the IPython console" dev-python/sympy
		optfeature "Import Matlab workspace files in the Variable Explorer" sci-libs/scipy
		optfeature "Run Cython files in the IPython console" dev-python/cython
		optfeature "The hdf5/h5py plugin" dev-python/h5py
		optfeature "The line profiler plugin" dev-python/spyder-line-profiler
		optfeature "The memory profiler plugin" dev-python/spyder-memory-profiler
		# spyder-autopep8 and spyder-vim do not have a release (yet)
		# and are not compatible with >=spyder-4.0.0 at the moment
		# optfeature "The autopep8 plugin" dev-python/spyder-autopep8
		# optfeature "Vim key bindings" dev-python/spyder-vim
		optfeature "Unittest support" dev-python/spyder-unittest
		optfeature "Jupyter notebook support" dev-python/spyder-notebook
		optfeature "System terminal inside spyder" dev-python/spyder-terminal
		# spyder-reports not yet updated to >=spyder-4.0.0
		# optfeature "Markdown reports using Pweave" dev-python/spyder-reports
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
