# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps go-module

MY_PN=go.d.plugin
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Netdata plugin for collectors written in Go"
HOMEPAGE="https://github.com/netdata/go.d.plugin"
SRC_URI="
	https://github.com/netdata/go.d.plugin/archive/refs/tags/v${PV}.tar.gz
		-> ${MY_P}.tar.gz
	https://github.com/netdata/go.d.plugin/releases/download/v${PV}/${MY_PN}-vendor-v${PV}.tar.gz
		-> ${MY_P}-vendor.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
# Dependent modules licenses
LICENSE+="
	Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0
"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="net-analyzer/netdata"
BDEPEND=">=dev-lang/go-1.21"

FILECAPS=(
	cap_net_raw /usr/libexec/netdata/plugins.d/go.d.plugin
)

src_compile() {
	LDFLAGS="-w -s -X main.version=${PV}-gentoo"
	ego build -ldflags "${LDFLAGS}" "github.com/netdata/go.d.plugin/cmd/godplugin"
}

src_test() {
	ego test ./... -cover -covermode=atomic
}

src_install() {
	einstalldocs

	exeinto "/usr/libexec/netdata/plugins.d"
	newexe godplugin go.d.plugin
	insinto "/usr/$(get_libdir)/netdata/conf.d"
	doins -r config/*
}
