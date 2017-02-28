# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
EGO_PN="golang.org/x/tools/..."

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	EGIT_COMMIT="ee8cb08bfe4453a27a4bd7c86a917800d339c5ac"
	ARCHIVE_URI="https://github.com/golang/tools/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go Tools"
HOMEPAGE="https://godoc.org/golang.org/x/tools"
SRC_URI="${ARCHIVE_URI}
	http://golang.org/favicon.ico -> go-favicon.ico"
LICENSE="BSD"
SLOT="0/${PVR}"
IUSE=""
DEPEND="dev-go/go-net:=
	>=dev-lang/go-1.5"
RDEPEND="!<dev-lang/go-1.5"

src_prepare() {
	local go_src="${EGO_PN%/...}"
	# disable broken tests
	rm src/${go_src}/cmd/bundle/main_test.go || die
	sed -e 's:TestWeb(:_\0:' \
		-e 's:TestWebIndex(:_\0:' \
		-i src/${go_src}/cmd/godoc/godoc_test.go || die
	sed -e 's:TestVet(:_\0:' \
		-e 's:TestDivergentPackagesExamples(:_\0:' \
		-e 's:TestIncompleteExamples(:_\0:' \
		-i src/${go_src}/cmd/vet/vet_test.go || die
	sed -e 's:TestImportStdLib(:_\0:' \
		-i src/${go_src}/go/gcimporter15/gcimporter_test.go || die
	sed -e 's:TestImportStdLib(:_\0:' \
		-i src/${go_src}/go/importer/import_test.go || die
	sed -e 's:TestStdlib(:_\0:' \
		-i src/${go_src}/go/loader/stdlib_test.go || die
	sed -e 's:TestStdlib(:_\0:' \
		-i src/${go_src}/go/ssa/stdlib_test.go || die
	sed -e 's:TestGorootTest(:_\0:' \
		-e 's:TestTestmainPackage(:_\0:' \
		-i src/${go_src}/go/ssa/interp/interp_test.go || die
	sed -e 's:TestBar(:_\0:' \
		-e 's:TestFoo(:_\0:' \
		-i src/${go_src}/go/ssa/interp/testdata/a_test.go || die
	sed -e 's:TestStdlib(:_\0:' \
		-e 's:TestStdFixed(:_\0:' \
		-e 's:TestStdKen(:_\0:' \
		-i src/${go_src}/go/types/stdlib_test.go || die
	sed -e 's:TestFindImportVendor(:_\0:' \
		-e 's:TestProcessVendor(:_\0:' \
		-i src/${go_src}/imports/fix_test.go || die

	# Add favicon to the godoc web interface (bug 551030)
	cp "${DISTDIR}"/go-favicon.ico "src/${go_src}/godoc/static/favicon.ico" ||
		die
	sed -e 's:"example.html",:\0\n\t"favicon.ico",:' \
		-i src/${go_src}/godoc/static/makestatic.go || die
	sed -e 's:<link type="text/css":<link rel="icon" type="image/png" href="/lib/godoc/favicon.ico">\n\0:' \
		-i src/${go_src}/godoc/static/godoc.html || die
}

src_compile() {
	# Generate static.go with favicon included
	pushd src/golang.org/x/tools/godoc/static >/dev/null || die
	go run makestatic.go || die
	popd >/dev/null

	golang-build_src_compile
}

src_test() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	cp -sR "$(go env GOROOT)" "${T}/goroot" || die
	mkdir -p "${T}/goroot/test" || die
	GOROOT="${T}/goroot" golang-build_src_test
	rm -rf "${T}/goroot"
}

src_install() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	cp -sR "$(go env GOROOT)" "${T}/goroot" || die
	cp -sR "$(get_golibdir_gopath)" "${T}/gopath" || die

	GOROOT="${T}/goroot" GOPATH="${WORKDIR}/${P}:${T}/gopath" go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
	golang_install_pkgs

	# bug 558818: install binaries in $GOROOT/bin to avoid file collisions
	exeinto "$(go env GOROOT)/bin"
	doexe bin/*
	# godoc location varies depending on whether or not it's
	# installed on the system (bug 591656)
	[[ -e bin/godoc ]] || doexe "${T}/goroot/bin/godoc"
	dodir /usr/bin
	ln "${ED}$(go env GOROOT)/bin/godoc" "${ED}usr/bin/godoc" || die

	rm "${D}"$(go env GOROOT)/bin/{cover,vet} || die
}
