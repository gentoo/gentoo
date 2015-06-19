# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hwloc/hwloc-1.10.1-r1.ebuild,v 1.1 2015/04/22 17:09:08 jer Exp $

EAPI=5

inherit flag-o-matic cuda autotools-multilib multilib versionator

MY_PV=v$(get_version_component_range 1-2)

DESCRIPTION="displays the hardware topology in convenient formats"
HOMEPAGE="http://www.open-mpi.org/projects/hwloc/"
SRC_URI="http://www.open-mpi.org/software/${PN}/${MY_PV}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="cairo cuda debug gl +numa opencl +pci plugins svg static-libs xml X"

# TODO opencl only works with AMD so no virtual
# dev-util/nvidia-cuda-toolkit is always multilib

RDEPEND=">=sys-libs/ncurses-5.9-r3[${MULTILIB_USEDEP}]
	cairo? ( >=x11-libs/cairo-1.12.14-r4[X?,svg?,${MULTILIB_USEDEP}] )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-6.5.19-r1 )
	gl? ( media-video/nvidia-settings )
	opencl? ( x11-drivers/ati-drivers:* )
	pci? (
		>=sys-apps/pciutils-3.3.0-r2[${MULTILIB_USEDEP}]
		>=x11-libs/libpciaccess-0.13.1-r1[${MULTILIB_USEDEP}]
	)
	plugins? ( dev-libs/libltdl:0[${MULTILIB_USEDEP}] )
	numa? ( >=sys-process/numactl-2.0.10-r1[${MULTILIB_USEDEP}] )
	xml? ( >=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

DOCS=( AUTHORS NEWS README VERSION )

PATCHES=(
	"${FILESDIR}/${PN}-1.8.1-gl.patch"
	"${FILESDIR}/hwloc-gather-topology-fix-lstopo-path-after-install.patch"
)
AUTOTOOLS_AUTORECONF=1

src_prepare() {
	if use cuda ; then
		append-cflags -I/opt/cuda/include
		append-cppflags -I/opt/cuda/include
	fi
	autotools-utils_src_prepare
}

multilib_src_configure() {
	export HWLOC_PKG_CONFIG=$(tc-getPKG_CONFIG) #393467
	use cuda && local LDFLAGS="${LDFLAGS} -L/opt/cuda/$(get_libdir)"
	local myeconfargs=(
		--disable-silent-rules
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable cairo)
		$(use_enable cuda)
		$(use_enable debug)
		$(multilib_native_use_enable gl)
		$(multilib_native_use_enable opencl)
		$(use_enable pci)
		$(use_enable plugins)
		$(use_enable numa libnuma)
		$(use_enable xml libxml2)
		$(use_with X x)
	)
	autotools-utils_src_configure
}
