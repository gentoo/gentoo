# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools

DEBIAN_PATCH="17"
DESCRIPTION="FAM, the File Alteration Monitor"
HOMEPAGE="http://oss.sgi.com/projects/fam/"
SRC_URI="ftp://oss.sgi.com/projects/fam/download/stable/${P}.tar.gz
	mirror://debian/pool/main/f/${PN}/${P/-/_}-${DEBIAN_PATCH}.diff.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="static-libs"

DEPEND="|| ( net-nds/rpcbind >=net-nds/portmap-5b-r6 )
	!app-admin/gamin"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog INSTALL NEWS TODO README )

src_prepare() {
	epatch "${WORKDIR}/${P/-/_}-${DEBIAN_PATCH}.diff"
	edos2unix "${S}"/${P}/debian/patches/10_debianbug375967.patch
	EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch "${S}"/${P}/debian/patches
	sed -i configure.ac -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files

	sed -i "${D}"/etc/fam.conf \
		-e "s:local_only = false:local_only = true:g" \
		|| die "sed fam.conf"

	doinitd "${FILESDIR}/famd"
}
