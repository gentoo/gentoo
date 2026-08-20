# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit cuda distutils-r1 edo pypi

DESCRIPTION="Python wrapper for NVIDIA CUDA"
HOMEPAGE="https://mathema.tician.de/software/pycuda/ https://pypi.org/project/pycuda/ https://github.com/inducer/pycuda"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples test"

RDEPEND="
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.24[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytools-2011.2[${PYTHON_USEDEP}]
	dev-util/nvidia-cuda-toolkit[profiler]
	x11-drivers/nvidia-drivers
"
DEPEND="${RDEPEND}"

# We need write acccess /dev/nvidia0 and /dev/nvidiactl and the portage
# user is (usually) not in the video group
RESTRICT="test? ( userpriv ) !test? ( test )"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
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
		--boost-inc-dir="${ESYSROOT}"/usr/include
		--boost-lib-dir="${ESYSROOT}"/usr/$(get_libdir)
		--boost-python-libname=boost_${EPYTHON/./}.so
		--boost-thread-libname=boost_thread
		--cuda-inc-dir="${ESYSROOT}"/opt/cuda/include
		--cuda-root="${ESYSROOT}"/opt/cuda
		--cudadrv-lib-dir="${ESYSROOT}"/usr/$(get_libdir)
		--cudart-lib-dir="${ESYSROOT}"/opt/cuda/$(get_libdir)
	)

	edo "${EPYTHON}" "${S}"/configure.py "${conf[@]}"
}

python_test() {
	# We need write access to these to run the tests
	addwrite /dev/nvidia0
	addwrite /dev/nvidiactl
	addwrite /dev/nvidia-uvm
	addwrite /dev/nvidia-uvm-tools

	if [[ ! -w /dev/nvidiactl ]]; then
		eerror "Could not write to /dev/nvidiactl. To run these tests, a NVIDIA GPU is required"
		eerror "and must be accessible by the package manager."
		eerror
		eerror "Further, the 'portage' user usually needs to be in the video group:"
		eerror " 1) set ACCT_USER_PORTAGE_GROUPS_ADD='video' in make.conf and re-emerge"
		eerror "    acct-user/portage, or"
		eerror
		eerror " 2) please run 'gpasswd -a portage video'."
		die "/dev/nvidiactl inaccessible; check permissions?"
	fi

	EPYTEST_DESELECT=(
		# needs investigation, perhaps failure is hardware-specific
		test/test_driver.py::test_pass_cai_array
		test/test_driver.py::test_pointer_holder_base
	)

	rm -rf pycuda || die
	epytest test
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
