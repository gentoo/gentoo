# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/openSUSE/umoci"
COMMIT=0465f83826bc4f52e6e3c4dbb1022ec5792c421f
inherit golang-vcs-snapshot

DESCRIPTION="Manipulation tool for OCI images"
HOMEPAGE="https://github.com/openSUSE/umoci"
SRC_URI="https://github.com/openSUSE/umoci/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-go/go-md2man"

S="${WORKDIR}/${P}/src/${EGO_PN}"

RESTRICT="test"

src_compile() {
	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go build -v -work -x \
	-ldflags "-w -X main.gitCommit=${COMMIT} -X main.version=${PV}" \
		-o "bin/${PN}" ./cmd/${PN}
	echo "$@"
	"$@" || die
	cd man
	for f in *.1.md; do
		go-md2man -in ${f} -out ${f%%.md} || die
	done
}

src_install() {
dobin bin/${PN}
doman man/*.1
dodoc CHANGELOG.md
einstalldocs
}
