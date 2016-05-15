# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils linux-mod multilib versionator

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2).$(get_version_component_range 3)"

DESCRIPTION="General-purpose Distributed Lock Manager"
HOMEPAGE="https://sourceware.org/cluster/wiki/"
SRC_URI="ftp://sourceware.org/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=sys-kernel/linux-headers-2.6.24
	!sys-cluster/dlm-headers
	!sys-cluster/dlm-kernel
	"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/${PN/-//}"

src_compile() {
	(cd "${WORKDIR}"/${MY_P};
		./configure \
			--cc=$(tc-getCC) \
			--cflags="-Wall" \
			--libdir="/usr/$(get_libdir)" \
			--disable_kernel_check \
			--kernel_src=${KERNEL_DIR} \
			--somajor="$MAJ_PV" \
			--sominor="$MIN_PV" \
			--cmanlibdir="/usr/$(get_libdir)" \
			--cmanincdir=/usr/include \
	) || die "configure problem"

	#emake clean || die "clean problem"
	emake -j1 || die "compile problem"
}

src_install() {
	emake DESTDIR="${D}" install || die "install problem"
}
