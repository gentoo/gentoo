# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_SRC="golang.org/x/tools"
EGO_PN="${EGO_SRC}/..."

# vendor the net package due to a circular dependency
GO_NET_COMMIT="aaf60122140d3fcf75376d319f0554393160eb50"
EGO_VENDOR=( "golang.org/x/net ${GO_NET_COMMIT} github.com/golang/net" )

if [[ ${PV} = *9999* ]]; then
	ARCHIVE_URI=""
	inherit golang-vcs
else
	EGIT_COMMIT="7d1dc997617fb662918b6ea95efc19faa87e1cf8"
	ARCHIVE_URI="https://github.com/golang/tools/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go Tools"
HOMEPAGE="https://godoc.org/golang.org/x/tools"
GO_FAVICON="go-favicon-20181103162401.ico"
SRC_URI="${ARCHIVE_URI}
	https://github.com/golang/net/archive/${GO_NET_COMMIT}.tar.gz -> github.com-golang-net-${GO_NET_COMMIT}.tar.gz
	mirror://gentoo/${GO_FAVICON}
	https://dev.gentoo.org/~zmedico/distfiles/${GO_FAVICON}"
LICENSE="BSD"
SLOT="0/${PVR}"

src_unpack() {
	golang-vcs_src_unpack
	mkdir -p "${WORKDIR}/${P}/src/${EGO_SRC}/vendor/golang.org/x/net" || die
	tar -C "${WORKDIR}/${P}/src/${EGO_SRC}/vendor/golang.org/x/net" -x --strip-components 1 \
		-f "${DISTDIR}/github.com-golang-net-${GO_NET_COMMIT}.tar.gz" || die
}

src_prepare() {
	default
	# Add favicon to the godoc web interface (bug 551030)
	cp "${DISTDIR}"/${GO_FAVICON} "src/${EGO_SRC}/godoc/static/favicon.ico" ||
		die
	sed -e 's:"example.html",:\0\n\t"favicon.ico",:' \
		-i src/${EGO_SRC}/godoc/static/gen.go || die
	sed -e 's:<link type="text/css":<link rel="icon" type="image/png" href="/lib/godoc/favicon.ico">\n\0:' \
		-i src/${EGO_SRC}/godoc/static/godoc.html || die
	sed -e 's:TestVeryLongFile(:_\0:' \
		-i src/${EGO_SRC}/go/internal/gcimporter/bexport_test.go || die
	sed -e 's:TestLoadSyntaxOK(:_\0:' \
		-i src/${EGO_SRC}/go/packages/packages_test.go || die
	sed -e 's:TestCgoOption(:_\0:' \
		-e 's:TestStdlib(:_\0:' \
		-i src/${EGO_SRC}/go/loader/stdlib_test.go || die
	sed -e 's:TestStdlib(:_\0:' \
		-i src/${EGO_SRC}/go/ssa/stdlib_test.go || die
	sed -e 's:TestWebIndex(:_\0:' \
		-e 's:TestTypeAnalysis(:_\0:' \
		-i src/${EGO_SRC}/cmd/godoc/godoc_test.go || die
	sed -e 's:TestImportStdLib(:_\0:' \
		-i src/${EGO_SRC}/go/internal/gcimporter/gcimporter_test.go || die
	sed -e 's:TestVeryLongFile(:_\0:' \
		-i src/${EGO_SRC}/go/internal/gcimporter/bexport_test.go || die
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #678964
	# Generate static.go with favicon included
	pushd src/golang.org/x/tools/godoc/static >/dev/null || die
	GOPATH="${S}" GOBIN="${S}/bin" \
		go run makestatic.go || die
	popd >/dev/null

	GOPATH="${S}" GOBIN="${S}/bin" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_test() {
	GOPATH="${S}" GOBIN="${S}/bin" \
		go test -v -work -x "${EGO_PN}" || die
}

src_install() {
	rm -rf "${S}/src/${EGO_SRC}/"{.git,vendor} || die
	golang_install_pkgs

	# bug 558818: install binaries in $GOROOT/bin to avoid file collisions
	exeinto "$(go env GOROOT)/bin"
	doexe bin/*
	dodir /usr/bin
	ln "${ED}$(go env GOROOT)/bin/godoc" "${ED}usr/bin/godoc" || die
}
