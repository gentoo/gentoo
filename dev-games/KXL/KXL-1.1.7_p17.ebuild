# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PV=$(ver_cut 1-3)
DESCRIPTION="Development Library for making games for X"
HOMEPAGE="http://kxl.orz.hm/"
# http://kxl.hn.org/download/${P}.tar.gz
SRC_URI="mirror://debian/pool/main/k/kxl/kxl_${MY_PV}.orig.tar.gz -> ${PN}-${MY_PV}.tar.gz"
SRC_URI+=" mirror://debian/pool/main/k/kxl/kxl_${MY_PV}-$(ver_cut 5).debian.tar.xz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-${MY_PV}-as-needed.patch
	"${FILESDIR}"/${PN}-${MY_PV}-ldflags.patch
	"${FILESDIR}"/${PN}-${MY_PV}-implicit-function-declarations.patch
)

src_prepare() {
	drop_debian_patch() {
		rm "${WORKDIR}"/debian/patches/$1 || die
		sed -i -e "/^${1}/d" "${WORKDIR}"/debian/patches/series || die
	}

	drop_debian_patch 000_soname_xlibs.diff

	eapply $(awk '{print $1}' "${WORKDIR}"/debian/patches/series | sed -e "s:^:${WORKDIR}/debian/patches/:")

	default

	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
