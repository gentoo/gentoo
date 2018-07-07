# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

inherit ruby-single multilib-minimal

DESCRIPTION="Alternative to vendor specific OpenCL ICD loaders"
HOMEPAGE="https://forge.imag.fr/projects/ocl-icd/"
SRC_URI="https://forge.imag.fr/frs/download.php/836/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${RUBY_DEPS}"
RDEPEND="app-eselect/eselect-opencl"

src_prepare() {
	generate_icd() {
		local sopath="/usr/$(get_libdir)/OpenCL/vendors/ocl-icd/libOpenCL.so"
		echo "${sopath}" > "${T}/ocl-icd-${ABI}.icd"
	}
	eapply_user
	multilib_copy_sources
	multilib_parallel_foreach_abi generate_icd
}

multilib_src_install() {
	default
	local OCL_DIR="${D%/}/usr/$(get_libdir)/OpenCL/vendors/ocl-icd"
	mkdir -p "${OCL_DIR}" || die "mkdir failed"
	mv "${D%/}/usr/$(get_libdir)"/libOpenCL* "${OCL_DIR}" || die

	insinto /etc/OpenCL/vendors/
	doins "${T}/ocl-icd-${ABI}.icd"
}

multilib_src_install_all() {
	find "${ED%/}" -name '*.la' -delete
}
