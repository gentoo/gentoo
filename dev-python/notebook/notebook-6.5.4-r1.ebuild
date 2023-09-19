# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi xdg-utils

DESCRIPTION="Jupyter Interactive Notebook"
HOMEPAGE="https://jupyter.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	<dev-libs/mathjax-3
	dev-python/argon2-cffi[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	>=dev-python/jupyter-core-4.6.1[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-5.3.4[${PYTHON_USEDEP}]
	>=dev-python/nbclassic-0.4.7[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/nest-asyncio-1.5[${PYTHON_USEDEP}]
	dev-python/prometheus-client[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17[${PYTHON_USEDEP}]
	>=dev-python/send2trash-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/terminado-0.8.3[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.1[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/jupyter-packaging-0.9[${PYTHON_USEDEP}]
	test? (
		dev-python/nbval[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/requests-unixsocket[${PYTHON_USEDEP}]
	)
"

PDEPEND=">=dev-python/nbconvert-4.2.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
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
	notebook/services/nbconvert/tests/test_nbconvert_api.py::APITest::test_list_formats
)

EPYTEST_IGNORE=(
	# selenium tests require geckodriver
	notebook/tests/selenium
)

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
