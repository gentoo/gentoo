# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=(
	"golang.org/x/tools a911d9008d1f732040244007778232b02ebb2b84 github.com/golang/tools"
)

inherit golang-vcs-snapshot

KEYWORDS="~amd64"
EGO_PN=github.com/chouquette/${PN}
HOMEPAGE="https://github.com/chouquette/coveraggregator"
EGIT_COMMIT="af12d4d73479a1b49a16bbed8e5c182999dd62be"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
DESCRIPTION="Cover profile aggregator for golang"
LICENSE="WTFPL-2 BSD"
RESTRICT="test"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND=""
S=${WORKDIR}/${P}/src/${EGO_PN}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #681202
	GOPATH="${WORKDIR}/${P}" go build -v -work -x ${EGO_BUILD_FLAGS} -o ${PN} "${EGO_PN}" || die
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
