# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Mstflint - an open source version of MFT (Mellanox Firmware Tools)"
HOMEPAGE="https://github.com/Mellanox/mstflint"
LICENSE="|| ( GPL-2 BSD-2 )"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="bd8852742cbd5d4d5eb0d67e000275c953cc0820"
MY_PV=${PV/_p/-}
MY_P=""
SRC_URI="https://github.com/Mellanox/mstflint/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
IUSE="adb-generic-tools inband ssl"
SLOT="0"
RDEPEND="dev-db/sqlite:3=
	sys-libs/zlib:=
	inband? ( sys-fabric/libibmad )
	adb-generic-tools? (
		dev-libs/boost:=
		dev-libs/expat:=
	)
	ssl? ( dev-libs/openssl:= )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default
	echo '#define TOOLS_GIT_SHA "'${EGIT_COMMIT}'"' > ./common/gitversion.h || die
}

src_configure() {
	eautoreconf
	econf $(use_enable inband) $(use_enable ssl openssl) $(use adb-generic-tools && printf -- '--enable-adb-generic-tools')
}

src_compile() {
	if use adb-generic-tools; then
		pushd ext_libs/json >/dev/null || die
		emake
		popd >/dev/null || die
	fi
	default
}
