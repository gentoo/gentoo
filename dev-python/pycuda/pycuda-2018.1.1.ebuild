# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit cuda distutils-r1

DESCRIPTION="Python wrapper for NVIDIA CUDA"
HOMEPAGE="https://mathema.tician.de/software/pycuda/ https://pypi.org/project/pycuda/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples opengl test"

RDEPEND="
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pytools-2013[${PYTHON_USEDEP}]
	dev-util/nvidia-cuda-toolkit
	x11-drivers/nvidia-drivers
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	test? (
		dev-python/mako[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}] )"

# We need write acccess /dev/nvidia0 and /dev/nvidiactl and the portage
# user is (usually) not in the video group
RESTRICT="userpriv !test? ( test )"

python_prepare_all() {
	cuda_sanitize
	sed -e "s:'--preprocess':\'--preprocess\', \'--compiler-bindir=$(cuda_gccdir)\':g" \
		-e "s:\"--cubin\":\'--cubin\', \'--compiler-bindir=$(cuda_gccdir)\':g" \
		-e "s:/usr/include/pycuda:${S}/src/cuda:g" \
		-i pycuda/compiler.py || die

	touch siteconf.py || die
	distutils-r1_python_prepare_all
}

python_configure() {
	mkdir -p "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die
	"${EPYTHON}" "${S}"/configure.py \
		--boost-inc-dir="${EPREFIX}/usr/include" \
		--boost-lib-dir="${EPREFIX}/usr/$(get_libdir)" \
		--boost-python-libname=boost_python-$(echo ${EPYTHON} | sed 's/python//')-mt \
		--boost-thread-libname=boost_thread-mt \
		--cuda-root="${EPREFIX}/opt/cuda" \
		--cudadrv-lib-dir="${EPREFIX}/usr/$(get_libdir)" \
		--cudart-lib-dir="${EPREFIX}/opt/cuda/$(get_libdir)" \
		--cuda-inc-dir="${EPREFIX}/opt/cuda/include" \
		--no-use-shipped-boost \
		$(usex opengl --cuda-enable-gl "") || die
}

src_test() {
	# we need write access to this to run the tests
	addwrite /dev/nvidia0
	addwrite /dev/nvidiactl
	addwrite /dev/nvidia-uvm
	addwrite /dev/nvidia-uvm-tools
	python_test() {
		pytest -vv || die "Tests fail with ${EPYTHON}"
	}
	distutils-r1_src_test
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples

	fi
}
