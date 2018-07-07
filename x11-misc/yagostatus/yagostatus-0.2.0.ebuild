# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build

EGO_PN="github.com/burik666/yagostatus"
DESCRIPTION="Yet Another i3status replacement written in Go"
HOMEPAGE="https://github.com/burik666/yagostatus"
LICENSE="GPL-3"
SLOT="0/${PVR}"
IUSE="pie"

EGO_VENDOR=(
	"golang.org/x/net 32a936f github.com/golang/net"
	"gopkg.in/yaml.v2 5420a8b github.com/go-yaml/yaml"
)

QA_PRESTRIPPED="usr/bin/yagostatus"

if [[ ${PV} == *9999* ]]; then
	inherit golang-vcs
else
	inherit golang-vcs-snapshot
	EGIT_COMMIT="v${PV}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
	KEYWORDS="~amd64"
fi

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	default
	export GOPATH="${G}:${EGO_STORE_DIR}"
	local mygoargs=(
		-v -work -x
		"-buildmode=$(usex pie pie default)"
		-asmflags "-trimpath=${S}"
		-gcflags "-trimpath=${S}"
		-ldflags "-s -w"
	)
	go build "${mygoargs[@]}" || die
}

src_install() {
	default
	dobin yagostatus
	dodoc README.md yagostatus.yml
	docompress -x "/usr/share/doc/${PF}"
}
