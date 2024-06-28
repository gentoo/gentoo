# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

MY_P=${P/_/-}
DESCRIPTION="Signature-based file format identification"
HOMEPAGE="
	https://www.itforarchivists.com/siegfried/
	https://github.com/richardlehane/siegfried/
"
SRC_URI="
	https://github.com/richardlehane/siegfried/archive/v${PV/_/-}.tar.gz
		-> ${MY_P}.gh.tar.gz
	https://github.com/richardlehane/siegfried/releases/download/v${PV/_/-}/data_${PV//[._]/-}.zip
		-> ${MY_P}-data.zip
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://dev.gentoo.org/~mgorny/dist/${P}_rc4.deps.tar.xz
	"
fi
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
# vendored deps
LICENSE+=" BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	!app-misc/dfshow
"

src_compile() {
	go build -v -work -x "${S}"/cmd/roy || die
	go build -v -work -x "${S}"/cmd/sf || die
}

src_test() {
	cp "${WORKDIR}/siegfried/fddXML.zip" cmd/roy/data || die
	go test -v "${S}"/cmd/roy || die
	go test -v "${S}"/cmd/sf || die
}

src_install() {
	dobin roy sf
	insinto /usr/share/siegfried
	doins "${WORKDIR}/siegfried/default.sig"
}
