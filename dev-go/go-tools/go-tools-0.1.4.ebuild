# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

EGIT_COMMIT="v${PV}"
ARCHIVE_URI="https://github.com/golang/tools/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"
DESCRIPTION="Tools that support the Go programming language (godoc, etc.)"
HOMEPAGE="https://godoc.org/golang.org/x/tools"
SLOT="0"
LICENSE="BSD MIT"

EGO_SUM=(
"github.com/yuin/goldmark v1.3.5"
"github.com/yuin/goldmark v1.3.5/go.mod"
"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
"golang.org/x/mod v0.4.2"
"golang.org/x/mod v0.4.2/go.mod"
"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
"golang.org/x/net v0.0.0-20210405180319-a5a99cb37ef4"
"golang.org/x/net v0.0.0-20210405180319-a5a99cb37ef4/go.mod"
"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c"
"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c/go.mod"
"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
"golang.org/x/sys v0.0.0-20210330210617-4fbd30eecc44/go.mod"
"golang.org/x/sys v0.0.0-20210510120138-977fb7262007"
"golang.org/x/sys v0.0.0-20210510120138-977fb7262007/go.mod"
"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
"golang.org/x/text v0.3.0/go.mod"
"golang.org/x/text v0.3.3/go.mod"
"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
)

go-module_set_globals
SRC_URI="
	${ARCHIVE_URI}
	${EGO_SUM_SRC_URI}
"

GO_TOOLS_PROGS=(
	authtest
	benchcmp
	bundle
	callgraph
	compilebench
	cookieauth
	cover
	digraph
	eg
	fieldalignment
	findcall
	fiximports
	getgo
	gitauth
	go-contrib-init
	godex
	godoc
	goimports
	gomvpkg
	gopackages
	gorename
	gostacks
	gotype
	goyacc
	guru
	helper
	html2article
	ifaceassert
	lostcancel
	netrcauth
	nilness
	present
	present2md
	server
	shadow
	splitdwarf
	ssadump
	stress
	stringer
	stringintconv
	toolstash
	unmarshal
)

S=${WORKDIR}/${P#go-}

src_unpack() {
	unpack "${P}.tar.gz"
	go-module_setup_proxy
}

src_prepare() {
	default
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
	sed -e 's:TestIExportData_stdlib(:_\0:' \
		-i go/internal/gcimporter/iexport_test.go || die
	sed -e 's:TestCgoOption(:_\0:' \
		-e 's:TestStdlib(:_\0:' \
		-i go/loader/stdlib_test.go || die
	sed -e 's:TestCgoBadPkgConfig(:_\0:' \
		-e 's:TestCgoMissingFile(:_\0:' \
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
		-e 's:TestStdlibNotPrefixed(:_\0:' \
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
		-e 's:TestModVendorAuto(:_\0:' \
		-e 's:TestScanNestedModuleInLocalReplace(:_\0:' \
		-i internal/imports/mod_test.go || die
	rm -f copyright/copyright_test.go || die
}

src_compile() {
	local packages
	readarray -t packages < <(go list ./...)
	(( ${#packages[@]} > 0 )) || die "go list failed"
	GOBIN="${S}/bin" go install -work "${packages[@]}"

	local expected_progs=("${GO_TOOLS_PROGS[@]}")
	local progs_diff=$(diff -u <(printf -- '%s\n' "${expected_progs[@]}"| LC_ALL=C sort) <(find bin -type f -printf '%f\n' | LC_ALL=C sort))
	if [[ -n ${progs_diff} ]]; then
		printf -- '%s\n' "${progs_diff}"
		die "difference in expected vs build programs"
	fi
}

src_test() {
	go test -work "./..." || die
}

src_install() {
	# bug 558818: install binaries in $GOROOT/bin to avoid file collisions
	exeinto "$(go env GOROOT)/bin"
	doexe bin/*
	dodir /usr/bin
	ln "${ED}/$(go env GOROOT)/bin/godoc" "${ED}/usr/bin/godoc" || die
}
