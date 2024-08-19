# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Tools that support the Go programming language (godoc, etc.)"
HOMEPAGE="https://pkg.go.dev/golang.org/x/tools"
SRC_URI="https://github.com/golang/tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"
S=${WORKDIR}/${P#go-}

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

# Many test failures.
RESTRICT="test"

GO_TOOLS_BINS=(
	authtest benchcmp bisect bundle callgraph compilebench cookieauth
	deadcode defers digraph eg fieldalignment file2fuzz findcall fiximports
	fuzz-driver fuzz-runner gitauth go-contrib-init godex godoc goimports
	gomvpkg gonew gopackages gorename gostacks gotype goyacc html2article
	httpmux ifaceassert lostcancel netrcauth nilness nodecount play present
	present2md shadow splitdwarf ssadump stress stringer stringintconv
	toolstash unmarshal unusedresult
)

src_compile() {
	local bin packages
	readarray -t packages < <(ego list ./... | grep -E "/($(echo "${GO_TOOLS_BINS[@]}" | tr ' ' '|'))$")
	GOBIN="${S}/bin" ego install -work "${packages[@]}"
}

src_test() {
	ego test -work ./...
}

src_install() {
	# bug 558818: install binaries in $GOROOT/bin to avoid file collisions
	local goroot=$(go env GOROOT)
	goroot=${goroot#${EPREFIX}}
	exeinto "${goroot}/bin"
	doexe bin/*
	dodir /usr/bin
	ln "${ED}/${goroot}/bin/godoc" "${ED}/usr/bin/godoc" || die
}
