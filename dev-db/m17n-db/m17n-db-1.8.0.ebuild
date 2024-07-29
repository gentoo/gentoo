# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

GLIBC_PV="2.39"
GLIBC_P="glibc-${GLIBC_PV}"

DESCRIPTION="Database for the m17n library"
HOMEPAGE="https://www.nongnu.org/m17n/"
SRC_URI="mirror://nongnu/m17n/${P}.tar.gz
	elibc_musl? ( mirror://gnu/glibc/${GLIBC_P}.tar.xz )"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE=""

RDEPEND="virtual/libintl"
BDEPEND="sys-devel/gettext"

CHARMAPS="${GLIBC_P}/localedata/charmaps"

src_unpack() {
	unpack ${P}.tar.gz

	if use elibc_musl; then
		tar xf "${DISTDIR}"/${GLIBC_P}.tar.xz ${CHARMAPS} || die
	fi
}

src_configure() {
	econf $(usex elibc_musl "--with-charmaps=${WORKDIR}/${CHARMAPS}" "")
}

src_install() {
	default

	docinto FORMATS
	dodoc FORMATS/*

	docinto UNIDATA
	dodoc UNIDATA/*
}
