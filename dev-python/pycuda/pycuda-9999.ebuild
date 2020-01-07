# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit cuda distutils-r1 git-r3 multilib

DESCRIPTION="Python wrapper for NVIDIA CUDA"
HOMEPAGE="https://mathema.tician.de/software/pycuda/ https://pypi.org/project/pycuda/"
SRC_URI=""
EGIT_REPO_URI="https://git.tiker.net/trees/pycuda.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples opengl test"

RDEPEND="
	dev-libs/boost[python,${PYTHON_USEDEP}]
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
	sed \
		-e "s:'--preprocess':\'--preprocess\', \'--compiler-bindir=$(cuda_gccdir)\':g" \
		-e "s:\"--cubin\":\'--cubin\', \'--compiler-bindir=$(cuda_gccdir)\':g" \
		-e "s:/usr/include/pycuda:${S}/src/cuda:g" \
		-i pycuda/compiler.py || die

	touch siteconf.py || die

	distutils-r1_python_prepare_all
}

python_configure() {
	local myopts=()
	use opengl && myopts+=( --cuda-enable-gl )

	mkdir "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die
	[[ -e ./siteconf.py ]] && rm -f ./siteconf.py
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
		"${myopts[@]}"
}

src_test() {
	# we need write access to this to run the tests
	addwrite /dev/nvidia0
	addwrite /dev/nvidiactl
	python_test() {
			py.test --debug -v -v -v || die "Tests fail with ${EPYTHON}"
	}
	distutils-r1_src_test
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
