# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/libfence/libfence-3.2.0.ebuild,v 1.1 2013/03/20 14:27:06 ultrabug Exp $

EAPI=4

inherit linux-info multilib toolchain-funcs versionator

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2-3)"

DESCRIPTION="Cluster Fencing Library"
HOMEPAGE="https://fedorahosted.org/cluster/wiki/HomePage"
SRC_URI="https://fedorahosted.org/releases/c/l/cluster/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="static-libs"

RDEPEND="~sys-cluster/libccs-${PV}"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.24"

S="${WORKDIR}/${MY_P}/fence"

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
		--fencelibdir=/usr/$(get_libdir) \
		--fenceincdir=/usr/include \
		--fencedlibdir=/usr/$(get_libdir) \
		--fencedincdir=/usr/include \
		--ccslibdir=/usr/$(get_libdir) \
		--ccsincdir=/usr/include \
	    || die "configure problem"
}

src_compile() {
	for i in libfence libfenced; do
		emake -C ${i}
	done
}

src_install() {
	for i in libfence libfenced; do
		emake DESTDIR="${D}" -C ${i} install
	done
	use static-libs || rm -f "${D}"/usr/lib*/*.a
}
