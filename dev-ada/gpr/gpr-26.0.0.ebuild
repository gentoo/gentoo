# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_{14..16} )
PYTHON_COMPAT=( python3_{10..13} )

inherit ada python-any-r1 multiprocessing

DESCRIPTION="LibGPR2 - Parser for GPR Project files"
HOMEPAGE="https://github.com/AdaCore/gpr"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static-libs static-pic test"
REQUIRED_USE="${ADA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${ADA_DEPS}
	dev-ada/xmlada[${ADA_USEDEP},shared,static-libs?,static-pic?]
	>=dev-ada/gnatcoll-core-26[${ADA_USEDEP},shared,static-libs?,static-pic?]
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},shared,static-libs?,static-pic?,iconv(+),gmp]
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
		abstract-importing-non-abstract aggregate ali_parser attribute \
		autoconf build-actions build_db build_makefile_parser \
		callgraph-install c-closure check-has-value check-mem \
		check-shared-lib-import command_line config \
		custom_attr_no_pack default-target disable_warnings display-version \
		empty_attribute_support explicit-target executable-directory \
		excluded_source_dirs externals-in-configuration-project \
		ignore_source_sub_dirs installed_asm_object \
		invalid-project invalid-project-2 invalid-trace-file kb \
		library load-preinstalled \
		multi-unit-3 nested-case nested-externals no-naming-package-in-config \
		options package-extension package-renaming parent-var-visible \
		parser-no-value prj-syntax-error process_manager runtime \
		self-project-attribute source subdirs target-checks tools \
		types-import unknown-var-config unit_filename_generator view_builder \
		build_db_dag/actions_signature tooling/source_dirs || die
}

src_compile() {
	local BUILD_ROOT=.build
	local KB_BUILD_DIR=${BUILD_ROOT}/kb
	mkdir -p ${KB_BUILD_DIR} || die
	cp kb/gpr2-kb-embedded.ads ${KB_BUILD_DIR} || die
	gprbuild -p -P kb/collect_kb.gpr -v -largs ${LDFLAGS} -cargs ${ADAFLAGS} \
		|| die
	.build/kb/collect_kb -o .build/kb /usr/share/gprconfig || die

	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=$1 \
			-XGPR2_BUILD=release -XXMLADA_BUILD=$1 gpr2.gpr \
			-largs ${LDFLAGS} \
			-cargs ${ADAFLAGS} || die "gprbuild failed"
	}
	build relocatable
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi

	gprbuild -p -m -v -j$(makeopts_jobs) -aP . -XGPR2_BUILD=release \
		-XLIBRARY_TYPE=relocatable -XXMLADA_BUILD=relocatable tools/gpr2_tools.gpr \
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
	build relocatable
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi

	gprinstall -p -f -v --prefix="${D}/usr" -XGPR2_BUILD=release \
		-XLIBRARY_TYPE=relocatable -XXMLADA_BUILD=relocatable \
		--build-name=relocatable --mode=usage tools/gpr2_tools.gpr || die

	sed -i \
		-e 's|"gpr2.build.view_tables.update_sources_list", ||g' \
		-e 's|"gpr2.tree_internal.load_autoconf", ||g' \
		"${D}"/usr/share/gpr/gpr2.gpr \
		|| die

	einstalldocs

	rm "${D}"/usr/bin/gprconfig || die
	rm "${D}"/usr/bin/gprbuild || die
	rm "${D}"/usr/bin/gprclean || die
	rm "${D}"/usr/bin/gprinstall || die

	rm -r "${D}"/usr/share/gpr/manifests || die
}
