# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Automated Component Toolkit code generator"
HOMEPAGE="https://github.com/Autodesk/AutomaticComponentToolkit"
SRC_URI="https://github.com/Autodesk/AutomaticComponentToolkit/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/AutomaticComponentToolkit-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"

RESTRICT="strip test"

BDEPEND="dev-lang/go"

QA_FLAGS_IGNORED="usr/bin/act"

src_compile() {
	cd Source || die
	go build -x -o ../${PN} *.go || die
}

src_install() {
	dobin ${PN}
	einstalldocs
	dodoc -r Documentation/.
}
