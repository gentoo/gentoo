# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils multilib versionator

CLUSTER_RELEASE=${PV}
MY_P=cluster-${CLUSTER_RELEASE}

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2).$(get_version_component_range 3)"

DESCRIPTION="Clustered resource group manager"
HOMEPAGE="http://sources.redhat.com/cluster/wiki/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="=sys-cluster/ccs-${CLUSTER_RELEASE}*
	=sys-cluster/dlm-lib-${CLUSTER_RELEASE}*
	=sys-cluster/cman-lib-${CLUSTER_RELEASE}*"

DEPEND="${RDEPEND}
	dev-libs/libxml2[-icu]
	=sys-libs/slang-2*"

S=${WORKDIR}/${MY_P}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-CVE-2010-3389.patch
	sed -i -e 's/-Werror//g' src/{clulib,utils,daemons}/Makefile || die
}

src_configure() {
	(cd "${WORKDIR}"/${MY_P};
		./configure \
			--cc="$(tc-getCC)" \
			--cflags="-Wall" \
			--disable_kernel_check \
			--somajor="$MAJ_PV" \
			--sominor="$MIN_PV" \
			--dlmlibdir=/usr/$(get_libdir) \
			--dlmincdir=/usr/include \
			--cmanlibdir=/usr/$(get_libdir) \
			--cmanincdir=/usr/include \
	) || die "configure problem"
}

src_compile() {
	# There's a problem with -O2 right now, a patch was submitted.
	env -u CFLAGS emake -j1 clean all || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	newinitd "${FILESDIR}"/${PN}-2.0x.rc ${PN} || die
	newconfd "${FILESDIR}"/${PN}-2.0x.conf ${PN} || die
}
