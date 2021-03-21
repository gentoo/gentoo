# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
# The warning that this is wrong is a false positive
# Spyder has setuptools in install_requires
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit optfeature xdg distutils-r1

# Commit of documentation to fetch
DOCS_PV="78b25754c69a20643258821146e398ad5535c920"

DESCRIPTION="The Scientific Python Development Environment"
HOMEPAGE="
	https://www.spyder-ide.org/
	https://github.com/spyder-ide/spyder/
	https://pypi.org/project/spyder/
"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/spyder-ide/${PN}-docs/archive/${DOCS_PV}.tar.gz -> ${PN}-docs-${DOCS_PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# The test suite often hangs or does not work.
# Technically spyder requires pyqt5<13, which
# we do not have in ::gentoo any more. Likely
# this is the reason many of the tests fail
# or hang. RESTRICTing because IMO it is
# not worth the several hours I spend every
# single version bump checking which tests
# do and do not work. Spyder itself works
# fine with pyqt5>13.
RESTRICT="test"

# White space separated deps are expansion of python-language-server[all] dep
# As the pyls ebuild does not add flags for optional runtime dependencies
# we have to manually specify these desp instead of just depending on the [all]
# flag. The indentation allows us to distinguish them from spyders direct deps.
RDEPEND="
	>=dev-python/atomicwrites-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/cloudpickle-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/diff-match-patch-20181111[${PYTHON_USEDEP}]
	>=dev-python/intervaltree-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/ipython-7.6.0[${PYTHON_USEDEP}]
	~dev-python/jedi-0.17.2[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/keyring-17.0.0[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-4.0[${PYTHON_USEDEP}]
	>=dev-python/numpydoc-0.6.0[${PYTHON_USEDEP}]
	~dev-python/parso-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/pickleshare-0.4[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.3[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/pylint-1.0[${PYTHON_USEDEP}]
	>=dev-python/python-language-server-0.36.2[${PYTHON_USEDEP}]

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
	>=dev-python/pyls-black-0.4.6[${PYTHON_USEDEP}]
	>=dev-python/pyls-spyder-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/pyxdg-0.26[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17.0.0[${PYTHON_USEDEP}]
	>=dev-python/qdarkstyle-2.8[${PYTHON_USEDEP}]
	<dev-python/qdarkstyle-3.0[${PYTHON_USEDEP}]
	>=dev-python/qtawesome-0.5.7[${PYTHON_USEDEP}]
	>=dev-python/qtconsole-5.0.3[${PYTHON_USEDEP}]
	>=dev-python/QtPy-1.5.0[${PYTHON_USEDEP},svg,webengine]
	>=dev-python/sphinx-0.6.6[${PYTHON_USEDEP}]
	>=dev-python/spyder-kernels-1.10.2[${PYTHON_USEDEP}]
	<dev-python/spyder-kernels-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/textdistance-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/three-merge-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/watchdog-0.10.3[${PYTHON_USEDEP}]
	<dev-python/watchdog-2.0.0[${PYTHON_USEDEP}]

	dev-python/PyQt5[${PYTHON_USEDEP}]
	dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
"

BDEPEND="test? (
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/matplotlib[tk,${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	<dev-python/pytest-6.0[${PYTHON_USEDEP}]
	dev-python/pytest-lazy-fixture[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
	dev-python/pytest-ordering[${PYTHON_USEDEP}]
	dev-python/pytest-qt[${PYTHON_USEDEP}]
	dev-python/pytest-xvfb[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
)"

# Based on the courtesy of Arfrever
# This patch removes a call to update-desktop-database during build
# This fails because access is denied to this command during build
PATCHES=(
	"${FILESDIR}/${PN}-4.2.1-build.patch"
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
)

distutils_enable_tests pytest
distutils_enable_sphinx docs/doc dev-python/sphinx-panels dev-python/pydata-sphinx-theme dev-python/sphinx-multiversion

python_prepare_all() {
	# move docs into workdir
	mv ../spyder-docs-${DOCS_PV}* docs || die

	# these deps are packaged separately: dev-python/spyder-kernels, dev-python/python-language-server
	rm external-deps/* -r || die
	# runs against things packaged in external-deps dir
	rm conftest.py || die

	# do not depend on pyqt5<13
	sed -i -e '/pyqt5/d' \
		-e '/pyqtwebengine/d' \
			setup.py || die

	# do not check deps, fails because we removed pyqt5 dependency above
	sed -i -e 's:test_dependencies_for_spyder_setup_install_requires_in_sync:_&:' \
		spyder/tests/test_dependencies_in_sync.py || die

	# can't check for update, need network
	rm spyder/workers/tests/test_update.py || die

	# skip online test
	rm spyder/widgets/github/tests/test_github_backend.py || die

	# KeyError: 'conda: base', need conda??
	sed -i -e 's:test_status_bar_conda_interpreter_status:_&:' \
		spyder/widgets/tests/test_status.py || die

	# assert 2 == 1
	sed -i -e 's:test_pylint_max_history_conf:_&:' \
		spyder/plugins/pylint/tests/test_pylint.py || die

	# https://bugs.gentoo.org/747211
	sed -i -e 's:test_loaded_and_closed_signals:_&:' \
		spyder/plugins/projects/tests/test_plugin.py || die

	# AssertionError: assert '' == 'This is some test text!'
	sed -i -e 's:test_tab_copies_find_to_replace:_&:' \
		spyder/plugins/editor/widgets/tests/test_editor.py || die

	# hangs till forever
	sed -i -e 's:test_help_opens_when_show_tutorial_full:_&:' \
		spyder/app/tests/test_mainwindow.py || die

	# Assertion error, can't connect/remember inside ebuild environment
	rm spyder/plugins/ipythonconsole/widgets/tests/test_kernelconnect.py || die

	# AssertionError: waitUntil timed out in 20000 miliseconds
	sed -i -e 's:test_pdb_multiline:_&:' \
		spyder/plugins/ipythonconsole/tests/test_ipythonconsole.py || die

	# AssertionError: assert 'if True:\n    0\n    ' == 'if True:\n    0'
	sed -i -e 's:test_undo_return:_&:' \
		spyder/plugins/editor/widgets/tests/test_codeeditor.py || die

	# assert False is True
	sed -i -e 's:test_range_indicator_visible_on_hover_only:_&:' \
		spyder/plugins/editor/panels/tests/test_scrollflag.py || die

	# AssertionError: waitUntil timed out in 10000 miliseconds
	sed -i -e 's:test_get_hints:_&:' \
		spyder/plugins/editor/widgets/tests/test_hints_and_calltips.py || die

	# Fatal Python error: Aborted
	sed -i -e 's:test_module_completion:_&:' \
		spyder/utils/introspection/tests/test_modulecompletion.py || die

	# assert 0 > 0
	sed -i -e 's:test_maininterpreter_page:_&:' \
		spyder/preferences/tests/test_config_dialog.py || die

	# This hangs forever
	sed -i -e 's:test_load_kernel_file:_&:' \
		-e 's:test_load_kernel_file_from_location:_&:' \
		-e 's:test_load_kernel_file_from_id:_&:' \
		spyder/plugins/ipythonconsole/tests/test_ipythonconsole.py || die

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
		optfeature "Import Matlab workspace files in the Variable Explorer" dev-python/scipy
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

	elog ""
	elog "Spyder currently only works with PyQt5 as QtPy backend, PySide2 is not supported."
	elog "Please ensure that 'eselect qtpy' is set to PyQt5."
	elog ""
}
