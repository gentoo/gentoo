# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
CMAKE_BUILD_TYPE="Release"

inherit python-any-r1 cmake-multilib flag-o-matic toolchain-funcs

DESCRIPTION="OpenCL implementation for Intel GPUs"
HOMEPAGE="https://01.org/beignet"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="ocl-icd"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://anongit.freedesktop.org/beignet"
	KEYWORDS=""
else
	KEYWORDS="~amd64"
	SRC_URI="https://01.org/sites/default/files/${P}-source.tar.gz"
	S=${WORKDIR}/Beignet-${PV}-Source
fi

COMMON="media-libs/mesa
	sys-devel/clang:0
	>=sys-devel/llvm-3.5:0
	>=x11-libs/libdrm-2.4.70[video_cards_intel]
	x11-libs/libXext
	x11-libs/libXfixes"
RDEPEND="${COMMON}
	app-eselect/eselect-opencl"
DEPEND="${COMMON}
	${PYTHON_DEPS}
	ocl-icd? ( dev-libs/ocl-icd )
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/no-debian-multiarch.patch
	"${FILESDIR}"/${P}-oclicd_optional_gentoo.patch
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
		-DCMAKE_INSTALL_PREFIX="${VENDOR_DIR}"
		-DOCLICD_COMPAT=$(usex ocl-icd)
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	VENDOR_DIR="/usr/$(get_libdir)/OpenCL/vendors/${PN}"

	cmake-utils_src_install

	insinto /etc/OpenCL/vendors/
	echo "${VENDOR_DIR}/lib/${PN}/libcl.so" > "${PN}-${ABI}.icd" || die "Failed to generate ICD file"
	doins "${PN}-${ABI}.icd"

	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libOpenCL.so.1
	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libOpenCL.so
	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libcl.so.1
	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libcl.so
}
