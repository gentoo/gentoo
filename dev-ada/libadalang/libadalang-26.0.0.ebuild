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
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test static-libs static-pic"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${ADA_DEPS}
	${PYTHON_DEPS}
	~dev-ada/gpr-26.0.0[${ADA_USEDEP},static-libs?,static-pic?]
	~dev-ada/langkit-contrib-26.0.0[${ADA_USEDEP},${PYTHON_SINGLE_USEDEP},static-libs?,static-pic?]
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

pkg_setup() {
	python-single-r1_pkg_setup
	ada_pkg_setup
}

src_prepare() {
	default
	rm -r testsuite/tests/{c_api,python}/gpr_ada_only || die
	rm -r testsuite/tests/misc/lkt_typer || die
	cd testsuite/tests/name_resolution || die
	rm -r {abort_signal,ada2012_iterator,address_clause,at_clause} || die
	rm -r {call_expr,deref_attribute,for_loop_6,stream_attrs} || die
	rm -r test_subp_address || die
}

src_configure() {
	${EPYTHON} -m langkit.scripts.lkm generate -v debug || die
}

src_compile() {
	local libType="relocatable"
	use static-libs && libType+=",static"
	use static-pic  && libType+=",static-pic"
	${EPYTHON} -m langkit.scripts.lkm build -v debug \
		--library-types ${libType} --jobs $(makeopts_jobs) \
		--disable-java \
		|| die
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
