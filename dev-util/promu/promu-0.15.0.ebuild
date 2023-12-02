# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Prometheus Utility Tool"
HOMEPAGE="https://github.com/prometheus/promu"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/prometheus/promu.git"
else
	SRC_URI="https://github.com/prometheus/promu/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://github.com/rahilarious/gentoo-distfiles/releases/download/${P}/deps.tar.xz -> ${P}-deps.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi
LICENSE="Apache-2.0"
LICENSE+=" BSD BSD-2 MIT"
SLOT="0"

RESTRICT+=" test"
DOCS=(
	"doc/examples"
	"README.md"
)

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	if use x86; then
		#917577 pie breaks build on x86
		GOFLAGS=${GOFLAGS//-buildmode=pie}
	fi
	emake build
}

src_install() {
	if [[ ${PV} == *9999 ]]; then
		dobin "${PN}"
	else
		newbin "${P}" "${PN}"
	fi
	einstalldocs
}
