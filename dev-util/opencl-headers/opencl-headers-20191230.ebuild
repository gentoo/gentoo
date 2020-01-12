# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib

DESCRIPTION="OpenCL Header files"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-Headers"

# Source:
# http://www.khronos.org/registry/cl/api/${CL_ABI}/opencl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_platform.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_ext.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_gl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_gl_ext.h

# Using copy by Mario Kicherer #496418

SRC_URI="
	https://github.com/KhronosGroup/OpenCL-Headers/archive/opencl10.zip
	https://github.com/KhronosGroup/OpenCL-Headers/archive/opencl11.zip
	https://github.com/KhronosGroup/OpenCL-Headers/archive/opencl12.zip
	https://github.com/KhronosGroup/OpenCL-Headers/archive/opencl20.zip
	https://github.com/KhronosGroup/OpenCL-Headers/archive/opencl21.zip
	"
LICENSE="Khronos-CLHPP"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""
S="${WORKDIR}"

DEPEND="app-arch/unzip"

src_install() {
	local headers=( opencl.h cl_platform.h cl.h cl_ext.h cl_gl.h cl_gl_ext.h cl_egl.h )

	# We install all versions of OpenCL headers
	for CL_ABI in 1.0 1.1 1.2 2.0 2.1; do
		mkdir -p "${ED}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABI}"
		for f in ${headers[@]}; do
			cp "${WORKDIR}"/OpenCL-Headers-opencl${CL_ABI/./}/${f} "${ED}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABI}/${f}"
		done
	done

	# Create symlinks to 1.2. Maybe this should be switchable?
	for f in ${headers[@]}; do
		dosym "../../$(get_libdir)/OpenCL/global/include/CL-1.2/${f}" "/usr/include/CL/${f}"
	done
}
