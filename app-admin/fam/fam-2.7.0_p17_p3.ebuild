# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic multilib-minimal toolchain-funcs

FAM_PV="${PV/_p*/}"
DEBIAN_PATCH="${PV#*_p}"
DEBIAN_PATCH="${DEBIAN_PATCH/_p/.}"
DESCRIPTION="FAM, the File Alteration Monitor"
HOMEPAGE="https://tracker.debian.org/pkg/fam"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${FAM_PV}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${FAM_PV}-${DEBIAN_PATCH}.diff.gz
"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"
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
PATCHES=(
	"${FILESDIR}"/${PN}-${FAM_PV}-AM_CONFIG_HEADER.patch
	"${FILESDIR}"/${PN}-${FAM_PV}-bindresvport.patch #729120
	"${FILESDIR}"/${PN}-${FAM_PV}-out-of-tree.patch
	"${FILESDIR}"/${PN}-${FAM_PV}-sysmacros.patch #580702
)

src_unpack() {
	default
	cd "${WORKDIR}" || die
	tar xzf "${WORKDIR}"/${PN}-${FAM_PV}/${PN}-${FAM_PV}.tar.gz || die
}

src_prepare() {
	find "${S}" -type f -exec chmod +w {} \; || die

	eapply "${WORKDIR}"/${PN}_${FAM_PV}-${DEBIAN_PATCH}.diff
	edos2unix debian/patches/10_debianbug375967.patch
	eapply "${FILESDIR}"/${PN}-${FAM_PV}-patch-header.patch
	eapply debian/patches/*patch

	default

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
	find "${ED}" -name '*.la' -delete || die

	einstalldocs

	sed -i "${D}"/etc/fam.conf \
		-e "s:local_only = false:local_only = true:g" \
		|| die "sed fam.conf"

	doinitd "${FILESDIR}/famd"
}
