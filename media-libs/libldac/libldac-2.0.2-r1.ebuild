# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

PACKAGING_VERSION="1.1"

DESCRIPTION="LDAC codec library from AOSP"
HOMEPAGE="https://android.googlesource.com/platform/external/libldac/"
SRC_URI="https://github.com/EHfive/ldacBT/releases/download/${PACKAGING_VERSION}-ldac.${PV}/ldacBT.tar.gz -> ${P}-${PACKAGING_VERSION}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/ldacBT"

src_prepare() {
	eapply_user
	mycmakeargs=( -DLDAC_SOFT_FLOAT=OFF -DINSTALL_LIBDIR=/usr/$(get_libdir) )
	cmake-utils_src_prepare
}
