# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN=golang.org/x/text/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm ~x86"
	EGIT_COMMIT="v${PV}"
	SRC_URI="https://github.com/golang/text/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go text processing support"
HOMEPAGE="https://godoc.org/golang.org/x/text"
LICENSE="BSD"
SLOT="0/${PVR}"
IUSE=""
DEPEND=">=dev-go/go-tools-0_pre20180817"
RDEPEND=""

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #680946
	# Create an isolated golibdir in order to avoid an
	# "use of internal package not allowed" error when
	# and older version is installed.
	mkdir -p "${T}/golibdir/src/golang.org/x" || die
	ln -s "$(get_golibdir_gopath)/src/golang.org/x/tools" "${T}/golibdir/src/golang.org/x/tools" || die
	GOPATH="${S}:${T}/golibdir" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
	golang_install_pkgs
	exeopts -m0755 -p # preserve timestamps for bug 551486
	exeinto "$(go env GOROOT)/bin"
	doexe bin/*
}

src_test() {
	GOPATH="${S}:${T}/golibdir" \
		go test -v -work -x "${EGO_PN}" || die
}
