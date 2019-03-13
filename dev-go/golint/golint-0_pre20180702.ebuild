# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="golang.org/x/lint/..."

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	EGIT_COMMIT=06c8688
	SRC_URI="https://github.com/golang/lint/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="a linter for Go"
HOMEPAGE="https://godoc.org/golang.org/x/tools"
LICENSE="BSD"
SLOT="0/${PVR}"
IUSE=""
DEPEND=">=dev-lang/go-1.6
	dev-go/go-tools"
RDEPEND="!<dev-lang/go-1.6
	dev-go/go-tools:="

DOCS=(
	src/golang.org/x/lint/CONTRIBUTING.md
	src/golang.org/x/lint/README.md
	src/golang.org/x/lint/misc
)

src_install() {
	golang-build_src_install
	einstalldocs
	dobin bin/*
}
