# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature xdg #virtualx

# Commit of documentation to fetch
DOCS_PV="fa91f0e9c8c2da33e7ec974e6b0e2a5ed6f04b10"

DESCRIPTION="The Scientific Python Development Environment"
HOMEPAGE="
	https://www.spyder-ide.org/
	https://github.com/spyder-ide/spyder/
	https://pypi.org/project/spyder/
"
SRC_URI="
	https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/spyder-ide/${PN}-docs/archive/${DOCS_PV}.tar.gz -> ${PN}-docs-${DOCS_PV}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/aiohttp-3.9.3[${PYTHON_USEDEP}]
	>=dev-python/asyncssh-2.14.0[${PYTHON_USEDEP}]
	<dev-python/asyncssh-3.0.0[${PYTHON_USEDEP}]
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
	>=dev-python/PyGithub-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/pylint-venv-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/python-lsp-black-2.0.0[${PYTHON_USEDEP}]
	<dev-python/python-lsp-black-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyls-spyder-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/pyuca-1.2[${PYTHON_USEDEP}]
	>=dev-python/qdarkstyle-3.2.0[${PYTHON_USEDEP}]
	<dev-python/qdarkstyle-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/qstylizer-0.2.2[${PYTHON_USEDEP}]
	>=dev-python/qtawesome-1.3.1[${PYTHON_USEDEP}]
	<dev-python/qtawesome-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/qtconsole-5.6.1[${PYTHON_USEDEP}]
	<dev-python/qtconsole-5.7.0[${PYTHON_USEDEP}]
	>=dev-python/QtPy-2.4.0[${PYTHON_USEDEP},quick,svg,webengine]
	>=dev-python/rtree-0.9.7[${PYTHON_USEDEP}]
	>=dev-python/sphinx-0.6.6[${PYTHON_USEDEP}]
	>=dev-python/spyder-kernels-3.0.0[${PYTHON_USEDEP}]
	<dev-python/spyder-kernels-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/superqt-0.6.2[${PYTHON_USEDEP}]
	<dev-python/superqt-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/textdistance-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/three-merge-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/watchdog-0.10.3[${PYTHON_USEDEP}]
	>=dev-python/yarl-1.9.4[${PYTHON_USEDEP}]
"

# BDEPEND="
# 	test? (
# 		dev-python/cython[${PYTHON_USEDEP}]
# 		dev-python/flaky[${PYTHON_USEDEP}]
# 		dev-python/matplotlib[tk,${PYTHON_USEDEP}]
# 		dev-python/pandas[${PYTHON_USEDEP}]
# 		dev-python/pillow[${PYTHON_USEDEP}]
# 		dev-python/pytest-lazy-fixture[${PYTHON_USEDEP}]
# 		dev-python/pytest-mock[${PYTHON_USEDEP}]
# 		dev-python/pytest-order[${PYTHON_USEDEP}]
# 		dev-python/pytest-qt[${PYTHON_USEDEP}]
# 		dev-python/pytest-timeout[${PYTHON_USEDEP}]
# 		dev-python/pyyaml[${PYTHON_USEDEP}]
# 		dev-python/QtPy[${PYTHON_USEDEP}]
# 		dev-python/scipy[${PYTHON_USEDEP}]
# 		dev-python/sympy[${PYTHON_USEDEP}]
# 	)"

# Based on the courtesy of Arfrever
# This patch removes a call to update-desktop-database during build
# This fails because access is denied to this command during build
PATCHES=(
	"${FILESDIR}/${PN}-5.0.0-build.patch"
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

# distutils_enable_tests pytest
# TODO: Package sphinx-design
# distutils_enable_sphinx docs/doc \
# 	dev-python/sphinx-panels \
# 	dev-python/pydata-sphinx-theme \
# 	dev-python/sphinx-multiversion

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
	# Do not depend on ipython, this dependency is carried in spyder-kernels
	# The explicit version requirements only make things more complicated, if e.g.
	# pyls-spyder gains compatibility with a newer version of python-lsp-server
	# in a new release it will take time for this information to propagate into
	# the next spyder release. So just remove the dependency and let the other
	# ebuilds handle the version requirements to speed things up and prevent
	# issues such as Bug 803269.
	sed -i \
		-e "/'pyqt5[ 0-9<=>.,]*',/d" \
		-e "/'pyqtwebengine[ 0-9<=>.,]*',/d" \
		-e "/'python-lsp-server\[all\][ 0-9<=>.,]*',/d" \
		-e "/'parso[ 0-9<=>.,]*',/d" \
		-e "/'jedi[ 0-9<=>.,]*',/d" \
		-e "/'pylint[ 0-9<=>.,]*',/d" \
			setup.py || die
		# -e "/'ipython[ 0-9<=>.,]*',/d" \
	sed -i \
		-e "/^PYLS_REQVER/c\PYLS_REQVER = '>=0.0.1'" \
		-e "/^PYLSP_REQVER/c\PYLSP_REQVER = '>=0.0.1'" \
		-e "/^PARSO_REQVER/c\PARSO_REQVER = '>=0.0.1'" \
		-e "/^JEDI_REQVER/c\JEDI_REQVER = '>=0.0.1'" \
		-e "/^PYLINT_REQVER/c\PYLINT_REQVER = '>=0.0.1'" \
			spyder/dependencies.py || die
		# -e "/^IPYTHON_REQVER/c\IPYTHON_REQVER = '>=0.0.1'" \

	# do not check deps, fails because we removed dependencies above
	sed -i -e 's:test_dependencies_for_spyder_setup_install_requires_in_sync:_&:' \
		spyder/tests/test_dependencies_in_sync.py || die

	# skip online test
	rm spyder/widgets/github/tests/test_github_backend.py || die

	distutils-r1_python_prepare_all
}

# Calling pytest directly somehow passes the pytest arguments to spyder
# causing an invalid argument error
# python_test() {
# 	virtx "${EPYTHON}" runtests.py
# }

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "2D/3D plotting in the Python and IPython consoles" dev-python/matplotlib
	optfeature "View and edit DataFrames and Series in the Variable Explorer" dev-python/pandas
	optfeature "View and edit two or three dimensional arrays in the Variable Explorer" dev-python/numpy
	optfeature "Symbolic mathematics in the IPython console" dev-python/sympy
	optfeature "Import Matlab workspace files in the Variable Explorer" dev-python/scipy
	optfeature "Run Cython files in the IPython console" dev-python/cython
	optfeature "The hdf5/h5py plugin" dev-python/h5py
	optfeature "The line profiler plugin" dev-python/spyder-line-profiler
	optfeature "Vim key bindings" dev-python/spyder-vim
	optfeature "Unittest support" dev-python/spyder-unittest
	optfeature "System terminal inside spyder" dev-python/spyder-terminal
	optfeature "Jupyter notebook support" dev-python/spyder-notebook
	# spyder-memory-profiler is not compatible with spyder-5.2+ yet
	# optfeature "The memory profiler plugin" dev-python/spyder-memory-profiler
	# spyder-reports not yet updated to >=spyder-4.0.0
	# optfeature "Markdown reports using Pweave" dev-python/spyder-reports
	# Plugins with no release yet:
	# optfeature "Manage virtual environments and packages" dev-python/spyder-env-manager
	# optfeature "VCS (e.g. git) integration" dev-python/spyder-vcs
}
