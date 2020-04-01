# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

MY_PN="OpenCL-Headers"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Unified C language headers for the OpenCL API"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-Headers"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"

multilib_src_install() {
	# Ideally we would install these directly into /usr/include but that would conflict
	# with eselect-opencl, therefore we install these into the vendor directory used by
	# dev-libs/opencl-icd-loader. Hopefully we will get this resolved soon and we can
	# stop messing with multilib in this package.
	local ocl_dir="/usr/$(get_libdir)/OpenCL/vendors/opencl-icd-loader"
	insinto "${ocl_dir}"/include
	doins -r "${S}"/CL
}
