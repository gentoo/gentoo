# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN="golang.org/x/tools"

EGO_VENDOR=(
	"golang.org/x/net 3b0461eec859c4b73bb64fdc8285971fd33e3938 github.com/golang/net"
	"golang.org/x/sync 112230192c580c3556b8cee6403af37a4fc5f28c github.com/golang/sync"
	"golang.org/x/xerrors a985d3407aa71f30cf86696ee0a2f409709f22e1 github.com/golang/xerrors"
)

EGIT_COMMIT="6bfd74cf029c99138aa1bb5b7e0d6b57c9d4eb49"
ARCHIVE_URI="https://github.com/golang/tools/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"
inherit golang-build golang-vcs-snapshot

DESCRIPTION="Tools that support the Go programming language (godoc, etc.)"
HOMEPAGE="https://godoc.org/golang.org/x/tools"
GO_FAVICON="go-favicon-20181103162401.ico"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}
	mirror://gentoo/${GO_FAVICON}
	https://dev.gentoo.org/~zmedico/distfiles/${GO_FAVICON}"
LICENSE="BSD"
SLOT="0/${PVR}"
S=${WORKDIR}/${P}/src/${EGO_PN}

src_prepare() {
	default
	# Add favicon to the godoc web interface (bug 551030)
	cp "${DISTDIR}"/${GO_FAVICON} "godoc/static/favicon.ico" ||
		die
	sed -e 's:"example.html",:\0\n\t"favicon.ico",:' \
		-i godoc/static/gen.go || die
	sed -e 's:<link type="text/css":<link rel="icon" type="image/png" href="/lib/godoc/favicon.ico">\n\0:' \
		-i godoc/static/godoc.html || die
	sed -e 's:TestDryRun(:_\0:' \
		-e 's:TestFixImports(:_\0:' \
		-i cmd/fiximports/main_test.go || die
	sed -e 's:TestWebIndex(:_\0:' \
		-e 's:TestTypeAnalysis(:_\0:' \
		-i cmd/godoc/godoc_test.go || die
	sed -e 's:TestApplyFixes(:_\0:' \
		-i go/analysis/internal/checker/checker_test.go || die
	sed -e 's:TestIntegration(:_\0:' \
		-i go/analysis/unitchecker/unitchecker_test.go || die
	sed -e 's:TestVeryLongFile(:_\0:' \
		-i go/internal/gcimporter/bexport_test.go || die
	sed -e 's:TestImportStdLib(:_\0:' \
		-i go/internal/gcimporter/gcimporter_test.go || die
	sed -e 's:TestCgoOption(:_\0:' \
		-e 's:TestStdlib(:_\0:' \
		-i go/loader/stdlib_test.go || die
	sed -e 's:TestCgoMissingFile(:_\0:' \
		-e 's:TestCgoNoCcompiler(:_\0:' \
		-e 's:TestConfigDefaultEnv(:_\0:' \
		-e 's:TestLoadSyntaxOK(:_\0:' \
		-e 's:TestMissingDependency(:_\0:' \
		-e 's:TestName_Modules(:_\0:' \
		-e 's:TestName_ModulesDedup(:_\0:' \
		-e 's:TestPatternPassthrough(:_\0:' \
		-i go/packages/packages_test.go || die
	sed -e 's:TestCgoOption(:_\0:' \
		-i go/packages/stdlib_test.go || die
	sed -e 's:TestStdlib(:_\0:' \
		-i go/ssa/stdlib_test.go || die
	sed -e 's:TestLocalPackagePromotion(:_\0:' \
		-e 's:TestLocalPrefix(:_\0:' \
		-e 's:TestSimpleCases(:_\0:' \
		-i internal/imports/fix_test.go || die
	sed -e 's:TestFindModFileModCache(:_\0:' \
		-e 's:TestInvalidModCache(:_\0:' \
		-e 's:TestModeGetmodeVendor(:_\0:' \
		-e 's:TestModCase(:_\0:' \
		-e 's:TestModDomainRoot(:_\0:' \
		-e 's:TestModList(:_\0:' \
		-e 's:TestModLocalReplace(:_\0:' \
		-e 's:TestModMultirepo3(:_\0:' \
		-e 's:TestModMultirepo4(:_\0:' \
		-e 's:TestModReplace1(:_\0:' \
		-e 's:TestModReplace2(:_\0:' \
		-e 's:TestModReplace3(:_\0:' \
		-e 's:TestModReplaceImport(:_\0:' \
		-e 's:TestScanNestedModuleInLocalReplace(:_\0:' \
		-i internal/imports/mod_test.go || die
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #678964
	export GOPATH="${WORKDIR}/${P}" GO111MODULE=on GOFLAGS="-mod=vendor -v -x"

	# Generate static.go with favicon included
	pushd godoc/static >/dev/null || die
	go run makestatic.go || die
	popd >/dev/null

	go install -work ${EGO_BUILD_FLAGS} \
		$(GOPATH="${WORKDIR}/${P}" go list ./...) || die
}

src_test() {
	go test -work "${EGO_PN}/..." || die
}

src_install() {
	rm -rf vendor || die
	pushd "${WORKDIR}/${P}"
	golang_install_pkgs
	popd >/dev/null

	# bug 558818: install binaries in $GOROOT/bin to avoid file collisions
	exeinto "$(go env GOROOT)/bin"
	doexe "${WORKDIR}/${P}"/bin/*
	dodir /usr/bin
	ln "${ED}/$(go env GOROOT)/bin/godoc" "${ED}/usr/bin/godoc" || die
}
