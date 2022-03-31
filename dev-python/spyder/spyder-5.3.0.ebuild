# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit optfeature xdg distutils-r1

# Commit of documentation to fetch
DOCS_PV="f99196cc267b07fa7ad56f0134744b545fa21fcd"

DESCRIPTION="The Scientific Python Development Environment"
HOMEPAGE="
	https://www.spyder-ide.org/
	https://github.com/spyder-ide/spyder/
	https://pypi.org/project/spyder/
"
SRC_URI="
	https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/spyder-ide/${PN}-docs/archive/${DOCS_PV}.tar.gz -> ${PN}-docs-${DOCS_PV}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# The test suite often hangs or does not work. Technically spyder requires
# pyqt5<13, which we do not have in ::gentoo any more. Likely this is the reason
# many of the tests fail or hang. RESTRICTing because IMO it is not worth the
# several hours I spend every single version bump checking which tests do and
# do not work. Spyder itself works fine with pyqt5>13.
RESTRICT="test"

RDEPEND="
	>=dev-python/atomicwrites-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.0.0[${PYTHON_USEDEP}]
	>=dev-util/cookiecutter-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/diff-match-patch-20181111[${PYTHON_USEDEP}]
	>=dev-python/intervaltree-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/jellyfish-0.7[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/keyring-17.0.0[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-4.0[${PYTHON_USEDEP}]
	>=dev-python/numpydoc-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/pickleshare-0.4[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.3[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/python-lsp-black-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyls-spyder-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/pyxdg-0.26[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17[${PYTHON_USEDEP}]
	>=dev-python/qdarkstyle-3.0.2[${PYTHON_USEDEP}]
	<dev-python/qdarkstyle-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/qstylizer-0.1.10[${PYTHON_USEDEP}]
	>=dev-python/qtawesome-1.0.2[${PYTHON_USEDEP}]
	>=dev-python/qtconsole-5.3.0[${PYTHON_USEDEP}]
	<dev-python/qtconsole-5.4.0[${PYTHON_USEDEP}]
	>=dev-python/QtPy-2.0.1[${PYTHON_USEDEP},svg,webengine]
	>=sci-libs/rtree-0.9.7[${PYTHON_USEDEP}]
	>=dev-python/sphinx-0.6.6[${PYTHON_USEDEP}]
	>=dev-python/spyder-kernels-2.3.0[${PYTHON_USEDEP}]
	<dev-python/spyder-kernels-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/textdistance-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/three-merge-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/watchdog-0.10.3[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/matplotlib[tk,${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pytest-lazy-fixture[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-ordering[${PYTHON_USEDEP}]
		<dev-python/pytest-qt-4[${PYTHON_USEDEP}]
		dev-python/pytest-xvfb[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
	)"

# Based on the courtesy of Arfrever
# This patch removes a call to update-desktop-database during build
# This fails because access is denied to this command during build
PATCHES=(
	"${FILESDIR}/${PN}-5.0.0-build.patch"
	"${FILESDIR}/${PN}-5.2.0-doc-theme-renamed.patch"
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
distutils_enable_sphinx docs/doc \
	dev-python/sphinx-panels \
	dev-python/pydata-sphinx-theme \
	dev-python/sphinx-multiversion

python_prepare_all() {
	# move docs into workdir
	mv ../spyder-docs-${DOCS_PV}* docs || die

	# these dependencies are packaged separately:
	#    dev-python/spyder-kernels,
	#    dev-python/python-lsp-server,
	#    dev-python/qdarkstyle
	rm -r external-deps/* || die
	# runs against things packaged in external-deps dir
	rm conftest.py || die

	# Do not depend on pyqt5<5.16, this dependency is carried by QtPy[pyqt5]
	# Do not depend on pyqtwebengine<5.16, this dependency is carried by QtPy[webengine]
	# Do not depend on parso and jedi, this is dependency is carried in python-lsp-server
	# Do not depend on python-lsp-server, this dependency is carried in pyls-spyder
	# The explicit version requirements only make things more complicated, if e.g.
	# pyls-spyder gains compatibility with a newer version of python-lsp-server
	# in a new release it will take time for this information to propagate into
	# the next spyder release. So just remove the dependency and let the other
	# ebuilds handle the version requirements to speed things up and prevent
	# issues such as Bug 803269.
	sed -i \
		-e '/pyqt5/d' \
		-e '/pyqtwebengine/d' \
		-e '/python-lsp-server/d' \
		-e '/parso/d' \
		-e '/jedi/d' \
		-e '/pylint/d' \
			requirements/conda.txt || die
	sed -i \
		-e "/'pyqt5[ 0-9<=>.,]*',/d" \
		-e "/'pyqtwebengine[ 0-9<=>.,]*',/d" \
		-e "/'python-lsp-server\[all\][ 0-9<=>.,]*',/d" \
		-e "/'parso[ 0-9<=>.,]*',/d" \
		-e "/'jedi[ 0-9<=>.,]*',/d" \
		-e "/'pylint[ 0-9<=>.,]*',/d" \
			setup.py || die
	sed -i \
		-e "/^PYLS_REQVER/c\PYLS_REQVER = '>=0.0.1'" \
		-e "/^PYLSP_REQVER/c\PYLSP_REQVER = '>=0.0.1'" \
		-e "/^PARSO_REQVER/c\PARSO_REQVER = '>=0.0.1'" \
		-e "/^JEDI_REQVER/c\JEDI_REQVER = '>=0.0.1'" \
		-e "/^PYLINT_REQVER/c\PYLINT_REQVER = '>=0.0.1'" \
			spyder/dependencies.py || die

	# do not check deps, fails because we removed dependencies above
	sed -i -e 's:test_dependencies_for_spyder_setup_install_requires_in_sync:_&:' \
		spyder/tests/test_dependencies_in_sync.py || die

	# can't check for update, need network
	rm spyder/workers/tests/test_update.py || die

	# skip online test
	rm spyder/widgets/github/tests/test_github_backend.py || die

	distutils-r1_python_prepare_all
}

# Calling pytest directly makes the tests freeze after completing even if successful
# Exit code is nonzero even upon success, so can't add || die here test results
# should be checked for success manually
python_test() {
	"${EPYTHON}" runtests.py
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "2D/3D plotting in the Python and IPython consoles" dev-python/matplotlib
	optfeature "View and edit DataFrames and Series in the Variable Explorer" dev-python/pandas
	optfeature "View and edit two or three dimensional arrays in the Variable Explorer" dev-python/numpy
	optfeature "Symbolic mathematics in the IPython console" dev-python/sympy
	optfeature "Import Matlab workspace files in the Variable Explorer" dev-python/scipy
	optfeature "Run Cython files in the IPython console" dev-python/cython
	optfeature "The hdf5/h5py plugin" dev-python/h5py
	# optfeature "The line profiler plugin" dev-python/spyder-line-profiler
	# optfeature "The memory profiler plugin" dev-python/spyder-memory-profiler
	# spyder-autopep8 does not have a release (yet)
	# and are not compatible with >=spyder-4.0.0 at the moment
	# optfeature "The autopep8 plugin" dev-python/spyder-autopep8
	# optfeature "Vim key bindings" dev-python/spyder-vim
	optfeature "Unittest support" dev-python/spyder-unittest
	# optfeature "Jupyter notebook support" dev-python/spyder-notebook
	optfeature "System terminal inside spyder" dev-python/spyder-terminal
	# spyder-reports not yet updated to >=spyder-4.0.0
	# optfeature "Markdown reports using Pweave" dev-python/spyder-reports
}
