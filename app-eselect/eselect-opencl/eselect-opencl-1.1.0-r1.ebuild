# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
CL_ABI=1.1

inherit multilib

DESCRIPTION="Utility to change the OpenCL implementation being used"
HOMEPAGE="http://www.gentoo.org/"

# Source:
# http://www.khronos.org/registry/cl/api/${CL_ABI}/opencl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_platform.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_ext.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_gl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_gl_ext.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl.hpp

MIRROR="http://dev.gentoo.org/~xarthisius/distfiles/"
SRC_URI="${MIRROR}/opencl.h.${CL_ABI}.xz
	${MIRROR}/cl_platform.h.${CL_ABI}.xz
	${MIRROR}/cl.h.${CL_ABI}.xz
	${MIRROR}/cl_ext.h.${CL_ABI}.xz
	${MIRROR}/cl_gl.h.${CL_ABI}.xz
	${MIRROR}/cl_gl_ext.h.${CL_ABI}.xz
	${MIRROR}/cl.hpp.${CL_ABI}.xz
	${MIRROR}/${P}-r1.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="app-arch/xz-utils"
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

	local headers=( opencl.h cl_platform.h cl.h cl_ext.h cl_gl.h cl_gl_ext.h cl.hpp )
	insinto /usr/$(get_libdir)/OpenCL/global/include/CL
	cd "${WORKDIR}"
	for f in ${headers[@]}; do
		newins ${f}.${CL_ABI} ${f}
	done
}
