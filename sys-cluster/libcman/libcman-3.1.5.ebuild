# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/libcman/libcman-3.1.5.ebuild,v 1.2 2011/10/18 20:53:42 jer Exp $

EAPI=4

inherit linux-info multilib toolchain-funcs versionator

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2-3)"

DESCRIPTION="Cluster Manager Library"
HOMEPAGE="https://fedorahosted.org/cluster/wiki/HomePage"
SRC_URI="https://fedorahosted.org/releases/c/l/cluster/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="static-libs"

DEPEND=">=sys-kernel/linux-headers-2.6.24"
RDEPEND="!sys-cluster/cman-lib"

S="${WORKDIR}/${MY_P}/cman/lib"

src_configure() {
	cd "${WORKDIR}/${MY_P}"
	./configure \
		--cc=$(tc-getCC) \
		--cflags="-Wall" \
		--libdir=/usr/$(get_libdir) \
		--disable_kernel_check \
		--kernel_src=${KERNEL_DIR} \
		--somajor="$MAJ_PV" \
		--sominor="$MIN_PV" \
		--cmanlibdir=/usr/$(get_libdir) \
		--cmanincdir=/usr/include \
		|| die "configure failed"
}

src_install() {
	default
	use static-libs || rm -f "${D}"/usr/lib*/*.a
}
