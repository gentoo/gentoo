# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps go-module

DESCRIPTION="Netdata plugin for collectors written in Go"
HOMEPAGE="https://github.com/netdata/netdata"
SRC_URI="
	https://github.com/netdata/netdata/releases/download/v${PV}/netdata-v${PV}.tar.gz
		-> netdata-${PV}.tar.gz
	https://dev.gentoo.org/~arkamar/distfiles/netdata-${PV}-vendor.tar.xz
"
S="${WORKDIR}/netdata-v${PV}/src/go"

LICENSE="GPL-3+"
# Dependent modules licenses
LICENSE+="
	Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0
"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="net-analyzer/netdata"
BDEPEND=">=dev-lang/go-1.22"

FILECAPS=(
	cap_net_raw /usr/libexec/netdata/plugins.d/go.d.plugin
)

src_compile() {
	LDFLAGS="-X main.version=${PV}-gentoo"
	ego build -ldflags "${LDFLAGS}" "github.com/netdata/netdata/go/plugins/cmd/godplugin"
}

src_test() {
	# skipped tests are sending udp packets to 192.0.2.1
	ego test -skip 'TestSNMP_Init/success_when_using_SNMPv[1-3]_with_valid_config' ./...
}

src_install() {
	einstalldocs

	exeinto "/usr/libexec/netdata/plugins.d"
	newexe godplugin go.d.plugin
	insinto "/usr/lib/netdata/conf.d"
	doins -r plugin/go.d/config/*
}
