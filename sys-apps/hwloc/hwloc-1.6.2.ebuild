# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib versionator

MY_PV=v$(get_version_component_range 1-2)

DESCRIPTION="displays the hardware topology in convenient formats"
HOMEPAGE="http://www.open-mpi.org/projects/hwloc/"
SRC_URI="http://www.open-mpi.org/software/${PN}/${MY_PV}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux"
IUSE="cairo debug +numa +pci plugins svg static-libs xml X"

RDEPEND="sys-libs/ncurses
	cairo? ( x11-libs/cairo[X?,svg?] )
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

src_configure() {
	export HWLOC_PKG_CONFIG=$(tc-getPKG_CONFIG) #393467
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable cairo) \
		$(use_enable debug) \
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
