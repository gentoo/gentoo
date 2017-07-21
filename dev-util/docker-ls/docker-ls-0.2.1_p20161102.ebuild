# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/mayflower/${PN}/..."
EGIT_COMMIT="3c5e2decd5c6717d4f375a2588179758d62bb591"
EGO_VENDOR=( "gopkg.in/yaml.v2 a3f3340b5840cee44f372bddb5880fcbc419b46a github.com/go-yaml/yaml"
	"golang.org/x/crypto 728b753d0135da6801d45a38e6f43ff55779c5c2 github.com/golang/crypto" )

inherit golang-build golang-vcs-snapshot

ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Tools for browsing and manipulating docker registries"
HOMEPAGE="https://github.com/mayflower/docker-ls"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="MIT"
SLOT="0"
IUSE=""

RESTRICT="test"

src_prepare() {
	default
	sed -i -e "s/\"git\", \"rev-parse\", \"--short\", \"HEAD\"/\"echo\", \"${EGIT_COMMIT:0:8}\"/"\
	src/${EGO_PN%/*}/generators/version.go || die
}

src_compile() {
	pushd src || die
	GOPATH="${WORKDIR}/${P}" go generate ${EGO_PN} || die
	GOPATH="${WORKDIR}/${P}" go install ${EGO_PN%/*}/cli/... || die
	popd || die
}

src_install() {
	dobin bin/*
	dodoc src/${EGO_PN%/*}/{README,CHANGELOG}.md
}
