# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

inherit eutils xdg distutils-r1 virtualx

# Commit of documentation to fetch
DOCS_PV="6abac0ce8be017c6ecfb2b451700bf5b0e4c36dd"

DESCRIPTION="The Scientific Python Development Environment"
HOMEPAGE="
	https://www.spyder-ide.org/
	https://github.com/spyder-ide/spyder/
	https://pypi.org/project/spyder/"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/spyder-ide/${PN}-docs/archive/${DOCS_PV}.tar.gz -> ${PN}-docs-${DOCS_PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Tests succeed, but freezes at the end, installation does not continue
RESTRICT="test"

RDEPEND="
	>=dev-python/atomicwrites-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/cloudpickle-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/diff-match-patch-20181111[${PYTHON_USEDEP}]
	dev-python/intervaltree[${PYTHON_USEDEP}]
	>=dev-python/ipython-4.0[${PYTHON_USEDEP}]
	~dev-python/jedi-0.15.2[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-4.0[${PYTHON_USEDEP}]
	>=dev-python/numpydoc-0.6.0[${PYTHON_USEDEP}]
	~dev-python/parso-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/pickleshare-0.4[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.3[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/pylint-0.25[${PYTHON_USEDEP}]
	>=dev-python/python-language-server-0.31.9[${PYTHON_USEDEP}]
	<dev-python/python-language-server-0.32.0[${PYTHON_USEDEP}]
	>=dev-python/pyxdg-0.26[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17.0.0[${PYTHON_USEDEP}]
	>=dev-python/qdarkstyle-2.8[${PYTHON_USEDEP}]
	>=dev-python/qtawesome-0.5.7[${PYTHON_USEDEP}]
	>=dev-python/qtconsole-4.6.0[${PYTHON_USEDEP}]
	>=dev-python/QtPy-1.5.0[${PYTHON_USEDEP},svg,webengine]
	>=dev-python/sphinx-0.6.6[${PYTHON_USEDEP}]
	>=dev-python/spyder-kernels-1.9.1[${PYTHON_USEDEP}]
	<dev-python/spyder-kernels-1.10.0[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
"

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
	dev-python/sympy[${PYTHON_USEDEP}]
	dev-python/xarray[${PYTHON_USEDEP}]
)"

# Based on the courtesy of Arfrever
# This patch removes a call to update-desktop-database during build
# This fails because access is denied to this command during build
PATCHES=(
	"${FILESDIR}/${PN}-4.1.2-build.patch"
	"${FILESDIR}/${PN}-4.1.2-py3-only.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs/doc --no-autodoc

python_prepare_all() {
	# move docs into workdir
	mv ../spyder-docs-${DOCS_PV}* docs || die

	# these deps are packaged separately
	rm external-deps/* -r || die

	# some tests still depend on QtPy[webkit] which is going to be removed
	# spyder itself works fine without webkit
	rm spyder/widgets/tests/test_browser.py || die
	rm spyder/plugins/onlinehelp/tests/test_pydocgui.py || die
	rm spyder/plugins/ipythonconsole/tests/test_ipythonconsole.py || die
	rm spyder/plugins/ipythonconsole/tests/test_ipython_config_dialog.py || die
	rm spyder/plugins/help/tests/test_widgets.py || die
	rm spyder/plugins/help/tests/test_plugin.py  || die
	# fails to collect
	rm spyder/app/tests/test_mainwindow.py || die

	# skip online test
	rm spyder/widgets/github/tests/test_github_backend.py || die

	# AssertionError: assert '' == 'This is some test text!'
	sed -i -e 's:test_tab_copies_find_to_replace:_&:' \
		spyder/plugins/editor/widgets/tests/test_editor.py || die

	# RuntimeError: Unsafe load() call disabled by Gentoo. See bug #659348
	sed -i -e 's:test_dependencies_for_binder_in_sync:_&:' \
		spyder/tests/test_dependencies_in_sync.py || die

	# Assertion error, can't connect/remember inside ebuild environment
	rm spyder/plugins/ipythonconsole/widgets/tests/test_kernelconnect.py || die

	# assert 77 in [71, 78] assert 45 in [43, 46]
	sed -i -e 's:test_objectexplorer_collection_types:_&:' \
		spyder/plugins/variableexplorer/widgets/objectexplorer/tests/test_objectexplorer.py || die

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

pkg_postinst() {
	xdg_pkg_postinst

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
		# spyder-autopep8 does not have a release (yet)
		# and are not compatible with >=spyder-4.0.0 at the moment
		# optfeature "The autopep8 plugin" dev-python/spyder-autopep8
		optfeature "Vim key bindings" dev-python/spyder-vim
		optfeature "Unittest support" dev-python/spyder-unittest
		optfeature "Jupyter notebook support" dev-python/spyder-notebook
		optfeature "System terminal inside spyder" dev-python/spyder-terminal
		# spyder-reports not yet updated to >=spyder-4.0.0
		# optfeature "Markdown reports using Pweave" dev-python/spyder-reports
}
