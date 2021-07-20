# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 xdg-utils

DESCRIPTION="Jupyter Interactive Notebook"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-libs/mathjax-2.4
	dev-python/argon2-cffi[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/terminado-0.8.3[${PYTHON_USEDEP}]
	>=www-servers/tornado-6.0[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1[${PYTHON_USEDEP}]
	>=dev-python/jupyter_core-4.6.1[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-5.3.4[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-4.2.0[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	dev-python/prometheus_client[${PYTHON_USEDEP}]"

# sphinx 2+ seems to have a problem with its github plugin. temporarily adding
# a version constraint.
BDEPEND="
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/requests-unixsocket[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}"-5.7.0-no-mathjax.patch
)

distutils_enable_tests --install pytest

python_prepare_all() {
	# disable bundled mathjax
	sed -i 's/^.*MathJax.*$//' bower.json || die

	distutils-r1_python_prepare_all
}

python_test() {
	local deselect=(
		# trash doesn't seem to work for us
		notebook/services/contents/tests/test_contents_api.py::APITest::test_checkpoints_follow_file
		notebook/services/contents/tests/test_contents_api.py::APITest::test_delete
		notebook/services/contents/tests/test_contents_api.py::GenericFileCheckpointsAPITest::test_checkpoints_follow_file
		notebook/services/contents/tests/test_contents_api.py::GenericFileCheckpointsAPITest::test_delete
		notebook/services/contents/tests/test_contents_api.py::GenericFileCheckpointsAPITest::test_delete_dirs
		notebook/services/contents/tests/test_contents_api.py::GenericFileCheckpointsAPITest::test_delete_non_empty_dir
		notebook/services/contents/tests/test_manager.py::TestContentsManager::test_delete
		notebook/services/contents/tests/test_manager.py::TestContentsManagerNoAtomic::test_delete
		# TODO
		notebook/services/kernels/tests/test_kernels_api.py::KernelAPITest::test_connections
		notebook/services/kernels/tests/test_kernels_api.py::AsyncKernelAPITest::test_connections
		notebook/services/kernels/tests/test_kernels_api.py::KernelCullingTest::test_culling
	)

	# selenium tests require geckodriver
	epytest --ignore notebook/tests/selenium ${deselect[@]/#/--deselect }
}

python_install() {
	distutils-r1_python_install

	ln -sf \
		"${EPREFIX}/usr/share/mathjax" \
		"${D}$(python_get_sitedir)/notebook/static/components/MathJax" || die
}

pkg_preinst() {
	# remove old mathjax folder if present
	rm -rf "${EROOT}"/usr/lib*/python*/site-packages/notebook/static/components/MathJax || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
