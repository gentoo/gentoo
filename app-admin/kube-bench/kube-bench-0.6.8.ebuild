# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Kubernetes Bench for Security runs the CIS Kubernetes Benchmark"
HOMEPAGE="https://github.com/aquasecurity/kube-bench"
SRC_URI="https://github.com/aquasecurity/kube-bench/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 MIT MPL-2.0 BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake KUBEBENCH_VERSION=v${PV} build
}

src_install() {
	dobin ${PN}
	insinto /etc/kube-bench
	doins -r cfg
}

src_test() {
	emake tests
}
