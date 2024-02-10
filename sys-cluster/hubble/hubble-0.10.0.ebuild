# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
# make sure this gets updated on every bump
GIT_HASH=daec1c89

DESCRIPTION="Network, Service & Security Observability for Kubernetes using eBPF"
HOMEPAGE="https://cilium.io"
SRC_URI="https://github.com/cilium/hubble/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake GIT_HASH=${GIT_HASH}
}

src_test() {
	emake test
}

src_install() {
	dobin hubble
}
