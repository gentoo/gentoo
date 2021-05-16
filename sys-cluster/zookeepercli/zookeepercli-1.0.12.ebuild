# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/outbrain/zookeepercli"
EGO_VENDOR=(
	"github.com/outbrain/golib ab954725f502c2be1491afadbbc66da2f99a45ae"
	"github.com/samuel/go-zookeeper c4fab1ac1bec58281ad0667dc3f0907a9476ac47"
)

inherit golang-vcs-snapshot

KEYWORDS="~amd64"
EGIT_COMMIT="v${PV}"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
S="${WORKDIR}/${P}/src/${EGO_PN}"
DESCRIPTION="Simple, lightweight, dependable CLI for ZooKeeper"
HOMEPAGE="https://github.com/outbrain/zookeepercli"
LICENSE="Apache-2.0 BSD"
SLOT="0"
IUSE=""
DEPEND=">=dev-lang/go-1.9:="

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #678960
	GOPATH="${WORKDIR}/${P}" \
		go build -v -work -x ${EGO_BUILD_FLAGS} \
		-o "${S}/bin/zookeepercli" \
		./go/cmd/zookeepercli.go || die
}

src_install() {
	dobin bin/${PN}
	dodoc README.md
}
