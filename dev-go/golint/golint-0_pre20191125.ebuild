# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

EGO_VENDOR=(
	"golang.org/x/tools a911d9008d1f732040244007778232b02ebb2b84 github.com/golang/tools"
)

EGIT_COMMIT=fdd1cda4f05fd1fd86124f0ef9ce31a0b72c8448
SRC_URI="https://github.com/golang/lint/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"
KEYWORDS="~amd64"

DESCRIPTION="a linter for Go"
HOMEPAGE="https://github.com/golang/lint"
LICENSE="BSD"
SLOT="0"
IUSE=""

S=${WORKDIR}/lint-${EGIT_COMMIT}

DOCS=(
	CONTRIBUTING.md
	README.md
	misc
)

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME
	env GOBIN="${S}/bin" go install ./... || die
}

src_install() {
	einstalldocs
	dobin bin/*
}
