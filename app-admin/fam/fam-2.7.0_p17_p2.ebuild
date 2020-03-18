# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils flag-o-matic ltprune multilib-minimal toolchain-funcs

FAM_PV="${PV/_p*/}"
DEBIAN_PATCH="${PV#*_p}"
DEBIAN_PATCH="${DEBIAN_PATCH/_p/.}"
DESCRIPTION="FAM, the File Alteration Monitor"
HOMEPAGE="http://oss.sgi.com/projects/fam/"
SRC_URI="
	ftp://oss.sgi.com/projects/fam/download/stable/${PN}-${FAM_PV}.tar.gz
	mirror://debian/pool/main/f/${PN}/${PN}_${FAM_PV}-${DEBIAN_PATCH}.diff.gz
"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86"
IUSE="static-libs"

DEPEND="
	!app-admin/gamin
	net-libs/libtirpc
	net-nds/rpcbind
"
RDEPEND="
	${DEPEND}
"
DOCS=( AUTHORS ChangeLog INSTALL NEWS TODO README )
S=${WORKDIR}/${PN}-${FAM_PV}

src_prepare() {
	eapply "${WORKDIR}"/${PN}_${FAM_PV}-${DEBIAN_PATCH}.diff
	edos2unix debian/patches/10_debianbug375967.patch
	eapply "${FILESDIR}"/${PN}-${FAM_PV}-patch-header.patch

	eapply debian/patches/*patch

	eapply "${FILESDIR}"/${PN}-${FAM_PV}-AM_CONFIG_HEADER.patch
	eapply "${FILESDIR}"/${PN}-${FAM_PV}-out-of-tree.patch
	eapply "${FILESDIR}"/${PN}-${FAM_PV}-sysmacros.patch #580702

	eapply_user

	eautoreconf
}

multilib_src_configure() {
	tc-export PKG_CONFIG
	append-cppflags $(${PKG_CONFIG} --cflags libtirpc)
	append-libs $(${PKG_CONFIG} --libs libtirpc)
	ECONF_SOURCE=${S} econf $(use_enable static-libs static)

	# These are thrown away later
	if ! multilib_is_native_abi ; then
		sed -i -e 's/src conf man//' Makefile || die
	fi
}

multilib_src_install_all() {
	prune_libtool_files
	einstalldocs

	sed -i "${D}"/etc/fam.conf \
		-e "s:local_only = false:local_only = true:g" \
		|| die "sed fam.conf"

	doinitd "${FILESDIR}/famd"
}
