# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hwloc/hwloc-1.7.2.ebuild,v 1.2 2013/11/16 16:09:13 xarthisius Exp $

EAPI=5

inherit flag-o-matic multilib versionator

MY_PV=v$(get_version_component_range 1-2)

DESCRIPTION="displays the hardware topology in convenient formats"
HOMEPAGE="http://www.open-mpi.org/projects/hwloc/"
SRC_URI="http://www.open-mpi.org/software/${PN}/${MY_PV}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux"
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

src_prepare() {
	if use cuda ; then
		append-cflags -I/opt/cuda/include
		append-cppflags -I/opt/cuda/include
		append-ldflags -L/opt/cuda/$(get_libdir)
	fi
}

src_configure() {
	export HWLOC_PKG_CONFIG=$(tc-getPKG_CONFIG) #393467
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable cairo) \
		$(use_enable cuda) \
		$(use_enable debug) \
		$(use_enable gl) \
		$(use_enable opencl) \
		$(use_enable pci) \
		$(use_enable pci libpci) \
		$(use_enable plugins) \
		$(use_enable numa libnuma) \
		$(use_enable static-libs static) \
		$(use_enable xml libxml2) \
		$(use_with X x) \
		--disable-silent-rules
}

src_install() {
	default
	if ! use static-libs; then
		rm "${D}"/usr/$(get_libdir)/lib${PN}.la
		use plugins && rm -f "${D}"/usr/$(get_libdir)/${PN}/*.la
	fi
}
