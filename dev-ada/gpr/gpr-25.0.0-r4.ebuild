# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_{14..16} )
PYTHON_COMPAT=( python3_{10..13} )

inherit ada python-any-r1 multiprocessing

DESCRIPTION="LibGPR2 - Parser for GPR Project files"
HOMEPAGE="https://github.com/AdaCore/gpr"
SRC_URI="https://github.com/AdaCore/${PN}/releases/download/v${PV}/gpr2-with-gprconfig_kb-$(ver_cut 1-2).tgz"

S="${WORKDIR}"/${PN}

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+shared static-libs static-pic test"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${ADA_DEPS}
	dev-ada/xmlada[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	=dev-ada/gnatcoll-core-25*[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},shared?,static-libs?,static-pic?,iconv(+),gmp]
"

DEPEND="${RDEPEND}
	dev-ada/gprconfig_kb[${ADA_USEDEP}]
	dev-ada/gprbuild[${ADA_USEDEP}]"
BDEPEND="test? (
	$(python_gen_any_dep '
		dev-ada/e3-testsuite[${PYTHON_USEDEP}]
	')
	dev-ada/gnatmem
)"

PATCHES=( "${FILESDIR}"/${P}-gcc16.patch )

python_check_deps() {
	use test || return 0
	python_has_version "dev-ada/e3-testsuite[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
	ada_pkg_setup
}

src_prepare() {
	default
	cd testsuite/tests
	rm -r \
		autoconf callgraph-install c-closure check-has-value \
		check-shared-lib-import configuration-file-error-handling \
		custom_attr_no_pack disable_warnings display-version \
		extending-add-body extending-interface-in-extended-project \
		externals-in-configuration-project installed_asm_object \
		invalid-project-2 kb-validation invalid-trace-file library-interfaces \
		multi-unit-3 nested-case nested-externals no-naming-package-in-config \
		parent-var-visible runtime-user-project self-project-attribute \
		source_subdirs subdirs types-import unknown-var-config view_builder \
		build_db_dag/actions_signature tooling/source_dirs || die
	rm -r ali_parser/dependencies || die
	cd tools
	rm -r gprls/closure/base || die
	rm -r gprls/closure/sal || dir
	rm -r gprls/closure/short-subunit-names || die
	rm -r gprls/closure/subunits || die
	rm -r gprclean/remove-empty-build-directories || die
	rm -r gprclean/no_build_dir_recursive || die
	rm -r gprclean/output-dir-not-found-warnings-not-printed || die
	rm -r gprinspect/text || die
}

src_compile() {
	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=$1 \
			-XGPR2_BUILD=release -XXMLADA_BUILD=$1 gpr2.gpr \
			-largs ${LDFLAGS} \
			-cargs ${ADAFLAGS} || die "gprbuild failed"
	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
	if use static-libs; then
		libtype='static'
	elif use static-pic; then
		libtype='static-pic'
	elif use shared; then
		libtype='relocatable'
	fi

	gprbuild -p -m -v -j$(makeopts_jobs) -aP . -XGPR2_BUILD=release \
		-XLIBRARY_TYPE=${libtype} -XXMLADA_BUILD=${libtype} tools/gpr2-tools.gpr \
		-largs ${LDFLAGS} -cargs ${ADAFLAGS} || die
}

src_test() {
	cd testsuite
	./testsuite.py |& grep -w FAIL && die
}

src_install() {
	build () {
		gprinstall -XLIBRARY_TYPE=$1 -f -p -v -XGPR2_BUILD=release \
			--prefix="${D}/usr" -XXMLADA_BUILD=$1 \
			--build-name=$1 --build-var=LIBRARY_TYPE \
			--build-var=GPR2_LIBRARY_TYPE gpr2.gpr || die
	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
	gprinstall -p -f -v -aP . -XGPR2_BUILD=release --prefix="${D}/usr" \
		-XLIBRARY_TYPE=${libtype} -XXMLADA_BUILD=${libtype} \
		--build-name=${libtype} --mode=usage tools/gpr2-tools.gpr || die

	einstalldocs

	rm "${D}"/usr/bin/gprconfig || die
	rm -r "${D}"/usr/share/gpr/manifests
}
