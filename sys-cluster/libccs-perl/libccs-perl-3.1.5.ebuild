# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/libccs-perl/libccs-perl-3.1.5.ebuild,v 1.1 2011/09/14 10:30:26 ultrabug Exp $

EAPI=4

inherit linux-info versionator

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2-3)"

DESCRIPTION="Cluster Configuration System Library Perl-Bindings"
HOMEPAGE="https://fedorahosted.org/cluster/wiki/HomePage"
SRC_URI="https://fedorahosted.org/releases/c/l/cluster/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-cluster/libccs"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.24"

S="${WORKDIR}/${MY_P}/bindings/perl"

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
		--ccslibdir=/usr/$(get_libdir) \
		--ccsincdir=/usr/include \
	    || die "configure problem"
}
