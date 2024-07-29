# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Kubernetes Operations"
HOMEPAGE="https://kops.sigs.k8s.io/ https://github.com/kubernetes/kops/"
SRC_URI="https://github.com/kubernetes/kops/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64"

# Failure needs investigation
RESTRICT="test"

src_compile() {
	export GOBIN="${WORKDIR}/${P}/bin"

	emake
}

src_install() {
	dobin bin/kops
}
