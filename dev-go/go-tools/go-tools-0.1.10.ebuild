# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Tools that support the Go programming language (godoc, etc.)"
HOMEPAGE="https://godoc.org/golang.org/x/tools"
SRC_URI="https://github.com/golang/tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

S=${WORKDIR}/${P#go-}

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
	rm -f go/analysis/passes/loopclosure/loopclosure_test.go || die
}

src_compile() {
	local packages
	readarray -t packages < <(ego list ./...)
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
