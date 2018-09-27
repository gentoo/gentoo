# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
CMAKE_BUILD_TYPE="Release"

inherit python-any-r1 cmake-multilib flag-o-matic llvm toolchain-funcs

DESCRIPTION="OpenCL implementation for Intel GPUs"
HOMEPAGE="https://01.org/beignet"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="ocl-icd ocl20"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/beignet.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64"
	SRC_URI="https://01.org/sites/default/files/${P}-source.tar.gz"
	S=${WORKDIR}/Beignet-${PV}-Source
fi

COMMON="app-eselect/eselect-opencl
	media-libs/mesa[${MULTILIB_USEDEP}]
	<sys-devel/clang-6.0.9999:=[${MULTILIB_USEDEP}]
	>=x11-libs/libdrm-2.4.70[video_cards_intel,${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	ocl-icd? ( dev-libs/ocl-icd )"
RDEPEND="${COMMON}"
DEPEND="${COMMON}
	${PYTHON_DEPS}
	virtual/pkgconfig"

LLVM_MAX_SLOT=6

PATCHES=(
	"${FILESDIR}"/no-debian-multiarch.patch
	"${FILESDIR}"/${PN}-1.3.2_disable-doNegAddOptimization.patch
	"${FILESDIR}"/${PN}-1.3.2_cmake-llvm-config-multilib.patch
	"${FILESDIR}"/${PN}-1.3.2_llvm6.patch
	"${FILESDIR}"/${PN}-1.3.1-oclicd_no_upstream_icdfile.patch
	"${FILESDIR}"/${PN}-1.2.0_no-hardcoded-cflags.patch
	"${FILESDIR}"/llvm-terminfo.patch
)

DOCS=(
	docs/.
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		if tc-is-gcc; then
			if [[ $(gcc-major-version) -eq 4 ]] && [[ $(gcc-minor-version) -lt 6 ]]; then
				eerror "Compilation with gcc older than 4.6 is not supported"
				die "Too old gcc found."
			fi
		fi
	fi
}

pkg_setup() {
	llvm_pkg_setup
	python_setup
}

src_prepare() {
	# See Bug #593968
	append-flags -fPIC

	cmake-utils_src_prepare
	# We cannot run tests because they require permissions to access
	# the hardware, and building them is very time-consuming.
	cmake_comment_add_subdirectory utests
}

multilib_src_configure() {
	VENDOR_DIR="/usr/$(get_libdir)/OpenCL/vendors/${PN}"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${VENDOR_DIR}"
		-DOCLICD_COMPAT=$(usex ocl-icd)
		$(usex ocl20 "" "-DENABLE_OPENCL_20=OFF")
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	VENDOR_DIR="/usr/$(get_libdir)/OpenCL/vendors/${PN}"

	cmake-utils_src_install

	insinto /etc/OpenCL/vendors/
	echo "${EPREFIX}${VENDOR_DIR}/lib/${PN}/libcl.so" > "${PN}-${ABI}.icd" || die "Failed to generate ICD file"
	doins "${PN}-${ABI}.icd"

	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libOpenCL.so.1
	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libOpenCL.so
	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libcl.so.1
	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libcl.so
}

pkg_postinst() {
	if use ocl-icd; then
		"${ROOT}"/usr/bin/eselect opencl set --use-old ocl-icd
	else
		"${ROOT}"/usr/bin/eselect opencl set --use-old beignet
	fi
}
