# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV="${PV/_p/-}"
EGIT_COMMIT="ab6f72086a2aa3a07629536fa091141f40a6f0c0"

DESCRIPTION="Mstflint - an open source version of MFT (Mellanox Firmware Tools)"
HOMEPAGE="https://github.com/Mellanox/mstflint"
SRC_URI="https://github.com/Mellanox/mstflint/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="adb-generic-tools inband ssl"

RDEPEND="
	dev-db/sqlite:3=
	sys-libs/zlib:=
	inband? ( sys-cluster/rdma-core )
	adb-generic-tools? (
		dev-libs/boost:=
		dev-libs/expat:=
	)
	ssl? ( dev-libs/openssl:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	echo '#define TOOLS_GIT_SHA "'${EGIT_COMMIT}'"' > ./common/gitversion.h || die
}

src_configure() {
	eautoreconf
	econf $(use_enable inband) $(use_enable ssl openssl) \
		  $(use adb-generic-tools && printf -- '--enable-adb-generic-tools')
}

src_compile() {
	if use adb-generic-tools; then
		pushd ext_libs/json >/dev/null || die
		emake
		popd >/dev/null || die
	fi
	default
}
