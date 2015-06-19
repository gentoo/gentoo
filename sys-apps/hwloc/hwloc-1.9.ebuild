# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hwloc/hwloc-1.9.ebuild,v 1.1 2014/04/08 08:47:02 alexxy Exp $

EAPI=5

inherit flag-o-matic cuda autotools-utils multilib versionator

MY_PV=v$(get_version_component_range 1-2)

DESCRIPTION="displays the hardware topology in convenient formats"
HOMEPAGE="http://www.open-mpi.org/projects/hwloc/"
SRC_URI="http://www.open-mpi.org/software/${PN}/${MY_PV}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="cairo cuda debug gl +numa opencl +pci plugins svg static-libs xml X"

# TODO opencl only works with AMD so no virtual

RDEPEND="sys-libs/ncurses
	cairo? ( x11-libs/cairo[X?,svg?] )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	gl? ( media-video/nvidia-settings )
	opencl? ( x11-drivers/ati-drivers )
	pci? (
			sys-apps/pciutils
			x11-libs/libpciaccess
		)
	plugins? ( sys-devel/libtool )
	numa? ( sys-process/numactl )
	xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README VERSION )

PATCHES=( "${FILESDIR}/${PN}-1.8.1-gl.patch" )
AUTOTOOLS_AUTORECONF=1

src_prepare() {
	if use cuda ; then
		append-cflags -I/opt/cuda/include
		append-cppflags -I/opt/cuda/include
		append-ldflags -L/opt/cuda/$(get_libdir)
	fi
	autotools-utils_src_prepare
}

src_configure() {
	export HWLOC_PKG_CONFIG=$(tc-getPKG_CONFIG) #393467
	local myeconfargs=(
		--disable-silent-rules
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable cairo)
		$(use_enable cuda)
		$(use_enable debug)
		$(use_enable gl)
		$(use_enable opencl)
		$(use_enable pci)
		$(use_enable pci libpci)
		$(use_enable plugins)
		$(use_enable numa libnuma)
		$(use_enable xml libxml2)
		$(use_with X x)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
}
