# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib

DESCRIPTION="Utility to change the OpenCL implementation being used"
HOMEPAGE="https://www.gentoo.org/"

# Source:
# http://www.khronos.org/registry/cl/api/${CL_ABI}/opencl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_platform.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_ext.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_gl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_gl_ext.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl.hpp

# Using copy by Mario Kicherer #496418

SRC_URI="
	https://dev.gentoo.org/~xarthisius/distfiles/${P}-r1.tar.xz
	https://github.com/KhronosGroup/OpenCL-Headers/archive/opencl10.zip
	https://github.com/KhronosGroup/OpenCL-Headers/archive/opencl11.zip
	https://github.com/KhronosGroup/OpenCL-Headers/archive/opencl12.zip
	https://github.com/KhronosGroup/OpenCL-Headers/archive/opencl20.zip
	https://github.com/KhronosGroup/OpenCL-Headers/archive/opencl21.zip
	http://packages.gentooexperimental.org/opencl-cpp-headers.tar
	"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND="
	app-arch/unzip
	app-arch/xz-utils"
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

	local headers=( opencl.h cl_platform.h cl.h cl_ext.h cl_gl.h cl_gl_ext.h cl_egl.h )

	# We install all versions of OpenCL headers
	for CL_ABI in 1.0 1.1 1.2 2.0 2.1; do
		mkdir -p "${ED}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABI}"
		for f in ${headers[@]}; do
			cp "${WORKDIR}"/OpenCL-Headers-opencl${CL_ABI/./}/${f} "${ED}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABI}/${f}" > /dev/null
		done
	done

	for i in 1.1 1.2 2.1; do
		cp "${WORKDIR}"/$i/cl.hpp "${ED}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABI}/"
	done
	# Create symlinks to newest. Maybe this should be switchable?
	for f in ${headers[@]}; do
		dosym "../../$(get_libdir)/OpenCL/global/include/CL-1.2/${f}" "/usr/include/CL/${f}"
	done
}
