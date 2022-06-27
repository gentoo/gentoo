# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools cuda flag-o-matic multilib-minimal toolchain-funcs

MY_PV=v$(ver_cut 1-2)

DESCRIPTION="Displays the hardware topology in convenient formats"
HOMEPAGE="https://www.open-mpi.org/projects/hwloc/"
SRC_URI="https://www.open-mpi.org/software/${PN}/${MY_PV}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="cairo cuda debug gl +numa +pci plugins svg static-libs xml X"

# opencl support dropped with x11-drivers/ati-drivers being removed (#582406).
# Anyone with hardware is welcome to step up and help test to get it re-added.

# dev-util/nvidia-cuda-toolkit is always multilib

RDEPEND=">=sys-libs/ncurses-5.9-r3:0[${MULTILIB_USEDEP}]
	cairo? ( >=x11-libs/cairo-1.12.14-r4[X?,svg?,${MULTILIB_USEDEP}] )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-6.5.19-r1:= )
	gl? ( x11-drivers/nvidia-drivers[static-libs,tools] )
	pci? (
		>=sys-apps/pciutils-3.3.0-r2[${MULTILIB_USEDEP}]
		>=x11-libs/libpciaccess-0.13.1-r1[${MULTILIB_USEDEP}]
	)
	plugins? ( dev-libs/libltdl:0[${MULTILIB_USEDEP}] )
	numa? ( >=sys-process/numactl-2.0.10-r1[${MULTILIB_USEDEP}] )
	xml? ( >=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-1.8.1-gl.patch" )
DOCS=( AUTHORS NEWS README VERSION )

src_prepare() {
	default
	eautoreconf

	if use cuda ; then
		append-cflags -I"${ESYSROOT}"/opt/cuda/include
		append-cppflags -I"${ESYSROOT}"/opt/cuda/include
	fi
}

multilib_src_configure() {
	export HWLOC_PKG_CONFIG=$(tc-getPKG_CONFIG) #393467

	if use cuda ; then
		local -x LDFLAGS="${LDFLAGS}"
		append-ldflags -L"${ESYSROOT}"/opt/cuda/$(get_libdir)
	fi

	ECONF_SOURCE=${S} econf \
		--disable-opencl \
		$(use_enable static-libs static) \
		$(use_enable cairo) \
		$(multilib_native_use_enable cuda) \
		$(use_enable debug) \
		$(multilib_native_use_enable gl) \
		$(use_enable pci) \
		$(use_enable plugins) \
		$(use_enable numa libnuma) \
		$(use_enable xml libxml2) \
		$(use_with X x)
}
