# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit bash-completion-r1 go-module

DESCRIPTION="Docker Bench for Security runs the CIS Docker Benchmark"
HOMEPAGE="https://github.com/aquasecurity/docker-bench"
SRC_URI="https://github.com/aquasecurity/docker-bench/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-vendor.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -mod=vendor -o ${PN} .
}

src_install() {
	dobin ${PN}
	insinto /etc/docker-bench/
	doins -r cfg
}
