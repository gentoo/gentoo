# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
ADA_COMPAT=( gcc_{14..16} )

inherit ada python-single-r1 multiprocessing

DESCRIPTION="high performance semantic engine for the Ada programming language"
HOMEPAGE="https://github.com/AdaCore/libadalang"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc test static-libs static-pic"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${ADA_DEPS}
	${PYTHON_DEPS}
	~dev-ada/gpr-25.0.0[${ADA_USEDEP},shared,static-libs?,static-pic?]
	~dev-ada/langkit-contrib-25.0.0[${ADA_USEDEP},${PYTHON_SINGLE_USEDEP},static-libs?,static-pic?]
	dev-python/pyyaml"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ada/gprbuild[${ADA_USEDEP}]
	$(python_gen_cond_dep '
		dev-ada/e3-core[${PYTHON_USEDEP}]
		doc? (
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		)
	')
	test? ( dev-ada/e3-testsuite )"

PATCHES=(
	"${FILESDIR}"/${PN}-23.0.0-test.patch
	"${FILESDIR}"/${P}-pipes.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
	ada_pkg_setup
}

src_prepare() {
	default
	rm -r testsuite/tests/ada_api/foreign_nodes || die
	rm -r testsuite/tests/ada_api/source_files || die
	rm -r testsuite/tests/{c_api,python}/gpr_ada_only || die
	rm -r testsuite/tests/lexical_envs/envs_* || die
	rm -r testsuite/tests/lexical_envs/records || die
	rm -r testsuite/tests/lexical_envs/gen_pkg_inst || die
	rm -r testsuite/tests/name_resolution/abort_signal || die
	rm -r testsuite/tests/name_resolution/ada2012_iterator || die
	rm -r testsuite/tests/name_resolution/address_clause || die
	rm -r testsuite/tests/name_resolution/at_clause || die
	rm -r testsuite/tests/name_resolution/call_expr || die
	rm -r testsuite/tests/name_resolution/concat_op || die
	rm -r testsuite/tests/name_resolution/deref_attribute || die
	rm -r testsuite/tests/name_resolution/entries_tasks_attrs || die
	rm -r testsuite/tests/name_resolution/for_loop_6 || die
	rm -r testsuite/tests/name_resolution/gnat_compare_implicit_references || die
	rm -r testsuite/tests/name_resolution/qual_expr_stmt || die
	rm -r testsuite/tests/name_resolution/stream_attrs || die
	rm -r testsuite/tests/name_resolution/test_subp_address || die
	rm -r testsuite/tests/properties/fully_qualified_name_4 || die
	rm -r testsuite/tests/properties/inherited_primitives_3 || die
	rm -r testsuite/tests/properties/get_primitives || die
}

src_configure() {
	${EPYTHON} manage.py generate -v debug || die
}

src_compile() {
	build () {
		gprbuild -v -p -j$(makeopts_jobs) -Pbuild/libadalang.gpr \
			-XLIBRARY_TYPE=$1 -XGPR_BUILD=$1 -XXMLADA_BUILD=$1 \
			-XLIBADALANG_WARNINGS=true \
			-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} \
			|| die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprbuild -v -p -j$(makeopts_jobs) -Pbuild/mains.gpr \
		-XLIBRARY_TYPE=relocatable -XGPR_BUILD=relocatable \
		-XXMLADA_BUILD=relocatable -XLIBADALANG_WARNINGS=true nameres.adb \
		gnat_compare.adb lal_dda.adb parse.adb lal_prep.adb unparse.adb \
		navigate.adb -cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} \
		-largs ${LDFLAGS} || die
	if use doc; then
		PYTHONPATH="${S}/build/python" \
			LD_LIBRARY_PATH="${S}/build/lib/relocatable/dev" \
			emake -C dev_manual html
		# Needs adadomain
		#PYTHONPATH="${S}/build/python" \
		#	LD_LIBRARY_PATH="${S}/build/lib/relocatable/dev" \
		#	emake -C user_manual html
	fi
}

src_test() {
	PATH="${S}/build/obj-mains/dev/:${PATH}" \
		GPR_PROJECT_PATH="${S}/build" \
		PYTHONPATH="${S}/build/python" \
		LD_LIBRARY_PATH="${S}/build/lib/relocatable/dev" \
		${EPYTHON} testsuite/testsuite.py || die
}

src_install() {
	build() {
		gprinstall -v -p -Pbuild/libadalang.gpr --prefix="${D}"/usr \
			--build-var=LIBRARY_TYPE --build-var=LIBADALANG_LIBRARY_TYPE \
			--sources-subdir=include/libadalang --build-name=$1 \
			-XLIBRARY_TYPE=$1 -XGPR_BUILD=$1 -XXMLADA_BUILD=$1 || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprinstall -v -p -Pbuild/mains.gpr --prefix="${D}"/usr \
		--build-var=LIBRARY_TYPE --build-var=MAINS_LIBRARY_TYPE \
		--mode=usage --build-name=relocatable -XLIBRARY_TYPE=relocatable \
		-XGPR_BUILD=relocatable -XXMLADA_BUILD=relocatable || die
	python_domodule build/python/libadalang
	if use doc; then
		HTML_DOCS=(dev_manual/_build/html/*)
	fi
	einstalldocs
}
