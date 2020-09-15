# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit eutils xdg distutils-r1

# Commit of documentation to fetch
DOCS_PV="7fbdabcbc37fe696e4ad5604cdbf4023dfbe8b6c"

MYPV="${PV/_alpha/a}"

DESCRIPTION="The Scientific Python Development Environment"
HOMEPAGE="
	https://www.spyder-ide.org/
	https://github.com/spyder-ide/spyder/
	https://pypi.org/project/spyder/"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${MYPV}.tar.gz -> ${P}.tar.gz
	https://github.com/spyder-ide/${PN}-docs/archive/${DOCS_PV}.tar.gz -> ${PN}-docs-${DOCS_PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Extra indented deps are expansion of python-language-server[all] dep
# As the pyls ebuild does not add flags for optional runtime dependencies
# we have to manually specify these desp instead of just depending on the [all]
# flag. The indentation allows us to distinguish them from spyders direct deps.
RDEPEND="
	>=dev-python/atomicwrites-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/cloudpickle-0.5.0[${PYTHON_USEDEP}]
	>=dev-util/cookiecutter-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/diff-match-patch-20181111[${PYTHON_USEDEP}]
	dev-python/intervaltree[${PYTHON_USEDEP}]
	>=dev-python/ipython-4.0[${PYTHON_USEDEP}]
	~dev-python/jedi-0.17.1[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-4.0[${PYTHON_USEDEP}]
	>=dev-python/numpydoc-0.6.0[${PYTHON_USEDEP}]
	~dev-python/parso-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/pickleshare-0.4[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.3[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/pylint-1.0[${PYTHON_USEDEP}]
	>=dev-python/python-language-server-0.34.0[${PYTHON_USEDEP}]

	dev-python/autopep8[${PYTHON_USEDEP}]
	>=dev-python/flake8-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/mccabe-0.6.0[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.6.0[${PYTHON_USEDEP}]
	<dev-python/pycodestyle-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/pydocstyle-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyflakes-2.2.0[${PYTHON_USEDEP}]
	<dev-python/pyflakes-2.3.0[${PYTHON_USEDEP}]
	dev-python/pylint[${PYTHON_USEDEP}]
	>=dev-python/rope-0.10.5[${PYTHON_USEDEP}]
	dev-python/yapf[${PYTHON_USEDEP}]

	<dev-python/python-language-server-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyxdg-0.26[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17.0.0[${PYTHON_USEDEP}]
	>=dev-python/qdarkstyle-2.8[${PYTHON_USEDEP}]
	>=dev-python/qtawesome-0.5.7[${PYTHON_USEDEP}]
	>=dev-python/qtconsole-4.6.0[${PYTHON_USEDEP}]
	>=dev-python/QtPy-1.5.0[${PYTHON_USEDEP},svg,webengine]
	>=dev-python/sphinx-0.6.6[${PYTHON_USEDEP}]
	>=dev-python/spyder-kernels-1.9.4[${PYTHON_USEDEP}]
	<dev-python/spyder-kernels-1.10.0[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
"

BDEPEND="test? (
	<dev-python/coverage-5.0[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/matplotlib[tk,${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	<dev-python/pytest-5.0[${PYTHON_USEDEP}]
	<dev-python/pytest-faulthandler-2.0[${PYTHON_USEDEP}]
	dev-python/pytest-lazy-fixture[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
	dev-python/pytest-ordering[${PYTHON_USEDEP}]
	dev-python/pytest-qt[${PYTHON_USEDEP}]
	dev-python/pytest-xvfb[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
)"

# Based on the courtesy of Arfrever
# This patch removes a call to update-desktop-database during build
# This fails because access is denied to this command during build
PATCHES=(
	"${FILESDIR}/${PN}-4.1.2-build.patch"
	"${FILESDIR}/${PN}-4.1.2-py3-only.patch"
	"${FILESDIR}/${PN}-4.1.5-doc-theme-renamed.patch"
)

DOCS=(
	"AUTHORS.txt"
	"Announcements.md"
	"CHANGELOG.md"
	"CODE_OF_CONDUCT.md"
	"CONTRIBUTING.md"
	"NOTICE.txt"
	"README.md"
	"RELEASE.md"
	"TROUBLESHOOTING.md"
)

S="${WORKDIR}/${PN}-${MYPV}"

distutils_enable_tests pytest
distutils_enable_sphinx docs/doc dev-python/sphinx-panels dev-python/pydata-sphinx-theme dev-python/sphinx-multiversion

python_prepare_all() {
	# move docs into workdir
	mv ../spyder-docs-${DOCS_PV}* docs || die

	# these deps are packaged separately: dev-python/spyder-kernels, dev-python/python-language-server
	rm external-deps/* -r || die

	# do not depend on pyqt5<13
	sed -i -e '/pyqt5/d' \
		-e '/pyqtwebengine/d' \
			setup.py || die

	# do not check deps, fails because we removed pyqt5 dependency above
	sed -i -e 's:test_dependencies_for_spyder_setup_install_requires_in_sync:_&:' \
		spyder/tests/test_dependencies_in_sync.py || die

	# some tests still depend on QtPy[webkit] which is removed
	# spyder itself works fine without webkit
	rm spyder/widgets/tests/test_browser.py || die
	rm spyder/plugins/onlinehelp/tests/test_pydocgui.py || die
	rm spyder/plugins/ipythonconsole/tests/test_ipythonconsole.py || die
	rm spyder/plugins/ipythonconsole/tests/test_ipython_config_dialog.py || die
	rm spyder/plugins/help/tests/test_widgets.py || die
	rm spyder/plugins/help/tests/test_plugin.py  || die
	rm spyder/app/tests/test_mainwindow.py || die

	# skip online test
	rm spyder/widgets/github/tests/test_github_backend.py || die

	# AssertionError: assert '' == 'This is some test text!'
	sed -i -e 's:test_tab_copies_find_to_replace:_&:' \
		spyder/plugins/editor/widgets/tests/test_editor.py || die

	# RuntimeError: Unsafe load() call disabled by Gentoo. See bug #659348
	sed -i -e 's:test_dependencies_for_binder_in_sync:_&:' \
		spyder/tests/test_dependencies_in_sync.py || die

	# Fatal Python error: Segmentation fault
	# sometimes it works, sometimes it segfaults
	sed -i -e 's:test_copy_path:_&:' \
		-e 's:test_copy_file:_&:' \
		-e 's:test_save_file:_&:' \
		-e 's:test_delete_file:_&:' \
		spyder/plugins/explorer/widgets/tests/test_explorer.py || die

	# Assertion error, can't connect/remember inside ebuild environment
	rm spyder/plugins/ipythonconsole/widgets/tests/test_kernelconnect.py || die

	# AssertionError: assert 47 in [43, 44, 45, 46]
	sed -i -e 's:test_objectexplorer_collection_types:_&:' \
		spyder/plugins/variableexplorer/widgets/objectexplorer/tests/test_objectexplorer.py  || die

	distutils-r1_python_prepare_all
}

# Calling pytest directly makes the tests freeze after completing even if successful
# Exit code is nonzero even upon success, so can't add || die here
# test results should be checked for success manually
python_test() {
	${EPYTHON} runtests.py
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
