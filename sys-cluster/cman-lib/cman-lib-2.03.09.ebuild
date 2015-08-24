# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils versionator

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2).$(get_version_component_range 3)"

DESCRIPTION="A library for cluster management common to the various pieces of Cluster Suite"
HOMEPAGE="https://sources.redhat.com/cluster/wiki/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="!sys-cluster/cman-headers
	!sys-cluster/cman-kernel
	!=sys-cluster/cman-1*
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/${PN/-//}"

src_compile() {
	(cd "${WORKDIR}"/${MY_P};
		./configure \
			--cc=$(tc-getCC) \
			--cflags="-Wall" \
			--disable_kernel_check \
			--somajor="$MAJ_PV" \
			--sominor="$MIN_PV" \
	) || die "configure problem"

	sed -e 's:\($(CC)\):\1 $(LDFLAGS):' -i Makefile
	sed -e 's:\($(CC)\):\1 $(LDFLAGS):' -i "${WORKDIR}/${MY_P}/make/cobj.mk"

	emake clean || die "clean problem"
	emake || die "compile problem"
}

src_install() {
	emake DESTDIR="${D}" install || die "install problem"
}
