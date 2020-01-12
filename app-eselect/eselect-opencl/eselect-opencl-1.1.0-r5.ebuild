# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib

DESCRIPTION="Utility to change the OpenCL implementation being used"
HOMEPAGE="https://www.gentoo.org/"

# Using copy by Mario Kicherer #496418

SRC_URI="
	https://dev.gentoo.org/~xarthisius/distfiles/${P}-r1.tar.xz
	http://packages.gentooexperimental.org/opencl-cpp-headers.tar
	"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND="
	app-arch/unzip
	app-arch/xz-utils
	dev-util/opencl-headers"
RDEPEND=">=app-admin/eselect-1.2.4"

pkg_postinst() {
	local impl="$(eselect opencl show)"
	if [[ -n "${impl}"  && "${impl}" != '(none)' ]] ; then
		eselect opencl set "${impl}"
	fi
}

src_install() {
	insinto /usr/share/eselect/modules
	doins opencl.eselect
	#doman opencl.eselect.5

	for CL_ABI in 1.1 1.2 2.1; do
		local idir="${ED}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABI}/"
		mkdir -p "${idir}"
		cp -v "${WORKDIR}/${CL_ABI}"/cl.hpp "${idir}"
	done
}
