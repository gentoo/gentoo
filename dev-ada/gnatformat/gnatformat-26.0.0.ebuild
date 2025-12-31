# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_{14..16} )
PYTHON_COMPAT=( python3_{11..13} )
inherit ada python-any-r1 multiprocessing

DESCRIPTION="Opinionated code formatter for the Ada language"
HOMEPAGE="https://github.com/AdaCore/gnatformat"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc static-pic static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="${ADA_DEPS}
	dev-ada/AdaSAT:=[${ADA_USEDEP},shared,static-libs?,static-pic?]
	>=dev-ada/gpr-26:=[${ADA_USEDEP},static-libs?,static-pic?]
	>=dev-ada/libadalang-26:=[${ADA_USEDEP},static-libs?,static-pic?]
	dev-ada/vss-extra:=[${ADA_USEDEP},static-libs?,static-pic?]"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ada/gprbuild[${ADA_USEDEP}]
	$(python_gen_any_dep '
		test? ( dev-ada/e3-testsuite[${PYTHON_USEDEP}] )
		doc? (
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		)
	')"

pkg_setup() {
	use test && python-any-r1_pkg_setup
	ada_pkg_setup
}

src_compile() {
	build () {
		gprbuild -P gnat/gnatformat.gpr -XGNATFORMAT_LIBRARY_TYPE=$1 \
			-XLIBRARY_TYPE=$1 -XGNATFORMAT_BUILD_MODE=dev -v -k -p \
			-j$(makeopts_jobs) -largs ${LDFLAGS} -cargs ${ADAFLAGS} \
			|| die "gprbuild failed"
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprbuild -P gnat/gnatformat_driver.gpr \
		-XGNATFORMAT_LIBRARY_TYPE=relocatable -XLIBRARY_TYPE=relocatable \
		-XGNATFORMAT_BUILD_MODE=dev -v -k -p -j$(makeopts_jobs) \
		-largs ${LDFLAGS} -cargs ${ADAFLAGS} || die "gprbuild failed"
	if use test; then
		GPR_PROJECT_PATH=gnat \
			gprbuild -P testsuite/test_programs/partial_gnatformat.gpr \
			-XGNATFORMAT_LIBRARY_TYPE=relocatable -XLIBRARY_TYPE=relocatable \
			-XGNATFORMAT_BUILD_MODE=dev -v -k -p -j$(makeopts_jobs) \
			-largs ${LDFLAGS} -cargs ${ADAFLAGS} || die "gprbuild failed"
	fi
	use doc && emake -C user_manual html
}

src_test() {
	PATH="${S}/testsuite/test_programs/bin/:${S}/bin:${PATH}" \
		${EPYTHON} testsuite/testsuite.py || die
}

src_install() {
	build () {
		gprinstall -v -XGNATFORMAT_LIBRARY_TYPE=$1 \
			-XLIBRARY_TYPE=$1 -XGNATFORMAT_BUILD_MODE=dev \
			--install-name=gnatformat --prefix="${D}"/usr \
			--sources-subdir=include/gnatformat \
			--build-name=$1 --build-var=LIBRARY_TYPE \
			-P gnat/gnatformat.gpr -p -f || die "gprinstall failed"
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprinstall -v -XGNATFORMAT_LIBRARY_TYPE=relocatable \
		-XLIBRARY_TYPE=relocatable -XBUILD_MODE=dev \
		--install-name=gnatformat --prefix="${D}"/usr \
		-P gnat/gnatformat_driver.gpr -p -f || die "gprinstall failed"
	use doc && HTML_DOCS=( user_manual/_build/html/* )
	einstalldocs
	rm -r "${D}"/usr/share/gpr/manifests
}
