# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="golang.org/x/tools"

# vendor the net package due to a circular dependency
EGO_VENDOR=( "golang.org/x/net aaf60122140d3fcf75376d319f0554393160eb50 github.com/golang/net" )

EGIT_COMMIT="7d1dc997617fb662918b6ea95efc19faa87e1cf8"
ARCHIVE_URI="https://github.com/golang/tools/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"
inherit golang-build golang-vcs-snapshot

DESCRIPTION="Go Tools"
HOMEPAGE="https://godoc.org/golang.org/x/tools"
GO_FAVICON="go-favicon-20181103162401.ico"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}
	mirror://gentoo/${GO_FAVICON}
	https://dev.gentoo.org/~zmedico/distfiles/${GO_FAVICON}"
LICENSE="BSD"
SLOT="0/${PVR}"

src_prepare() {
	default
	# Add favicon to the godoc web interface (bug 551030)
	cp "${DISTDIR}"/${GO_FAVICON} "src/${EGO_PN}/godoc/static/favicon.ico" ||
		die
	sed -e 's:"example.html",:\0\n\t"favicon.ico",:' \
		-i src/${EGO_PN}/godoc/static/gen.go || die
	sed -e 's:<link type="text/css":<link rel="icon" type="image/png" href="/lib/godoc/favicon.ico">\n\0:' \
		-i src/${EGO_PN}/godoc/static/godoc.html || die
	sed -e 's:TestVeryLongFile(:_\0:' \
		-i src/${EGO_PN}/go/internal/gcimporter/bexport_test.go || die
	sed -e 's:TestLoadSyntaxOK(:_\0:' \
		-i src/${EGO_PN}/go/packages/packages_test.go || die
	sed -e 's:TestCgoOption(:_\0:' \
		-i src/${EGO_PN}/go/loader/stdlib_test.go || die
	sed -e 's:TestWebIndex(:_\0:' \
		-e 's:TestTypeAnalysis(:_\0:' \
		-i src/${EGO_PN}/cmd/godoc/godoc_test.go || die
	sed -e 's:TestImportStdLib(:_\0:' \
		-i src/${EGO_PN}/go/internal/gcimporter/gcimporter_test.go || die
	sed -e 's:TestVeryLongFile(:_\0:' \
		-i src/${EGO_PN}/go/internal/gcimporter/bexport_test.go || die
}

src_compile() {
	# Generate static.go with favicon included
	pushd src/golang.org/x/tools/godoc/static >/dev/null || die
	GOPATH="${S}:$(get_golibdir_gopath)" \
		go run makestatic.go || die
	popd >/dev/null

	GOPATH="${S}:$(get_golibdir_gopath)" \
		go install -v -work -x ${EGO_BUILD_FLAGS} $(cd "${S}/src/${EGO_PN}" && GOPATH="${S}" go list ./...) || die
}

src_test() {
	GOPATH="${S}:$(get_golibdir_gopath)" \
		go test -v -work -x "${EGO_PN}/..." || die
}

src_install() {
	rm -rf "${S}/src/${EGO_PN}/vendor" || die
	golang_install_pkgs

	# bug 558818: install binaries in $GOROOT/bin to avoid file collisions
	exeinto "$(go env GOROOT)/bin"
	doexe bin/*
	dodir /usr/bin
	ln "${ED}$(go env GOROOT)/bin/godoc" "${ED}usr/bin/godoc" || die
}
