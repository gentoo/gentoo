# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Signature-based file format identification"
HOMEPAGE="
	https://www.itforarchivists.com/siegfried/
	https://github.com/richardlehane/siegfried/
"
SRC_URI="
	https://github.com/richardlehane/siegfried/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/richardlehane/siegfried/releases/download/v${PV}/data_1-11-0.zip
		-> ${P}-data.zip
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://dev.gentoo.org/~mgorny/dist/${P}.deps.tar.xz
	"
fi

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
	newenvd - 99siegfried <<-EOF
		SIEGFRIED_HOME="${EPREFIX}/usr/share/siegfried"
	EOF
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "We use SIEGFRIED_HOME environment variable to point Siegfried"
		elog "to the signature file.  Please source /etc/profile to make it"
		elog "work.  If you would like to use another home directory, check"
		elog "the -home option."
	fi
}
