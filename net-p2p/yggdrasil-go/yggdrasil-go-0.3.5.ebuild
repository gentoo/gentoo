# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/yggdrasil-network/yggdrasil-go"
EGO_VENDOR=(
	"github.com/docker/libcontainer 5dc7ba0f24332273461e45bc49edcb4d5aa6c44c"
	"github.com/gologme/log 4e5d8ccb38e83c62d829cf88456808e0d9c56df4"
	"github.com/hjson/hjson-go a25ecf6bd2223d1d5a8cef7ac7be8a4d60a90a61"
	"github.com/kardianos/minwinsvc cad6b2b879b0970e4245a20ebf1a81a756e2bb70"
	"github.com/mitchellh/mapstructure 3536a929edddb9a5b34bd6861dc4a9647cb459fe"
	"github.com/songgao/packets 549a10cd4091c1e78542d3bb357036299cb9fcd6"
	"github.com/yggdrasil-network/water f732c88f34aeb1785591e30dd55362ba1c7f2132"
	"golang.org/x/crypto 505ab145d0a99da450461ae2c1a9f6cd10d1f447 github.com/golang/crypto"
	"golang.org/x/net 610586996380ceef02dd726cc09df7e00a3f8e56 github.com/golang/net"
	"golang.org/x/sys 70b957f3b65e069b4930ea94e2721eefa0f8f695 github.com/golang/sys"
	"golang.org/x/text f21a4dfb5e38f5895301dc265a8def02365cc3d0 github.com/golang/text"
)

inherit golang-vcs-snapshot linux-info systemd

SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

DESCRIPTION="An experiment in scalable routing as an encrypted IPv6 overlay network"
HOMEPAGE="https://yggdrasil-network.github.io/"
LICENSE="LGPL-3"

SLOT="0"
IUSE=""
KEYWORDS="~amd64"

QA_PRESTRIPPED="/usr/bin/yggdrasil /usr/bin/yggdrasilctl"

pkg_setup() {
	linux-info_pkg_setup
	if ! linux_config_exists; then
		eerror "Unable to check your kernel for TUN support"
	else
		CONFIG_CHECK="~TUN"
		ERROR_TUN="Your kernel lacks TUN support."
	fi
}

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go install -v -work -x -ldflags "\
		-X ${EGO_PN}/src/yggdrasil.buildName=yggdrasil \
		-X ${EGO_PN}/src/yggdrasil.buildVersion=${PV} \
		-s -w" \
		${EGO_PN}/cmd/... || die
}

src_install() {
	dobin bin/*

	systemd_dounit "src/${EGO_PN}/contrib/systemd/yggdrasil.service"
	newinitd "src/${EGO_PN}/contrib/openrc/yggdrasil" yggdrasil
}
