# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )
inherit cuda distutils-r1 pypi

DESCRIPTION="Python wrapper for NVIDIA CUDA"
HOMEPAGE="https://mathema.tician.de/software/pycuda/ https://pypi.org/project/pycuda/"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples opengl test"

RDEPEND="
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pytools[${PYTHON_USEDEP}]
	dev-util/nvidia-cuda-toolkit[profiler]
	x11-drivers/nvidia-drivers
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}"

# We need write acccess /dev/nvidia0 and /dev/nvidiactl and the portage
# user is (usually) not in the video group
RESTRICT="test? ( userpriv ) !test? ( test )"

distutils_enable_tests pytest

src_prepare() {
	cuda_sanitize

	sed "s|\"--preprocess\"|&,\"--compiler-bindir=$(cuda_gccdir)\"|" \
		-i pycuda/compiler.py || die

	> siteconf.py || die

	distutils-r1_src_prepare
}

python_configure() {
	mkdir -p "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die

	local conf=(
		"${EPYTHON}" "${S}"/configure.py
		--boost-inc-dir="${ESYSROOT}"/usr/include
		--boost-lib-dir="${ESYSROOT}"/usr/$(get_libdir)
		--boost-python-libname=boost_${EPYTHON/./}.so
		--boost-thread-libname=boost_thread
		--cuda-inc-dir="${ESYSROOT}"/opt/cuda/include
		--cuda-root="${ESYSROOT}"/opt/cuda
		--cudadrv-lib-dir="${ESYSROOT}"/usr/$(get_libdir)
		--cudart-lib-dir="${ESYSROOT}"/opt/cuda/$(get_libdir)
		--no-use-shipped-boost
		$(usev opengl --cuda-enable-gl)
	)
	echo ${conf[*]}
	"${conf[@]}" || die
}

python_test() {
	# we need write access to this to run the tests
	addwrite /dev/nvidia0
	addwrite /dev/nvidiactl
	addwrite /dev/nvidia-uvm
	addwrite /dev/nvidia-uvm-tools

	EPYTEST_DESELECT=(
		# needs investigation, perhaps failure is hardware-specific
		test/test_driver.py::test_pass_cai_array
		test/test_driver.py::test_pointer_holder_base
	)

	cd "${T}" || die
	epytest "${S}"/test
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
