# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ADA_COMPAT=( gcc_{13..16} )
PYTHON_COMPAT=( python3_{10..13} )

inherit ada python-any-r1 multiprocessing

DESCRIPTION="Port of the Prettier formatter to the Ada programming language"
HOMEPAGE="https://github.com/AdaCore/prettier-ada"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+shared static-libs static-pic test"

RDEPEND="${ADA_DEPS}
	dev-ada/vss-text:=[${ADA_USEDEP},shared(+)?,static-libs?,static-pic?]
	dev-ada/gnatcoll-core:=[${ADA_USEDEP},shared?,static-libs?,static-pic?]"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"
BDEPEND="test? (
	$(python_gen_any_dep '
		dev-ada/e3-testsuite[${PYTHON_USEDEP}]
	')
)"

REQUIRED_USE="${ADA_REQUIRED_USE}
	|| ( shared static-libs static-pic )
	test? ( static-libs )"
RESTRICT="!test? ( test )"

python_check_deps() {
	use test || return 0
	python_has_version "dev-ada/e3-testsuite[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
	ada_pkg_setup
}

src_compile() {
	build() {
		gprbuild \
			-v \
			-k \
			-XLIBRARY_TYPE=$1 \
			-XPRETTIER_ADA_LIBRARY_TYPE=$1 \
			-P prettier_ada.gpr \
			-p \
			-j$(makeopts_jobs) \
			-largs ${LDFLAGS} \
			-cargs ${ADAFLAGS} \
			|| die "gprbuild failed"
	}
	use shared && build relocatable
	use static-libs && build static
	use static-pic && build static-pic
}

src_install() {
	build() {
		gprinstall \
			-XPRETTIER_ADA_LIBRARY_TYPE=$1 \
			-XLIBRARY_TYPE=$1 \
			--prefix="${D}"/usr \
			--install-name=prettier_ada \
			--build-name=$1 \
			--build-var=LIBRARY_TYPE \
			-P prettier_ada.gpr -p -f \
			|| die "gprinstall failed"

	}
	use shared && build relocatable
	use static-libs && build static
	use static-pic && build static-pic
	einstalldocs
}

src_test() {
	gprbuild \
		-v \
		-k \
		-XLIBRARY_TYPE=static \
		-XPRETTIER_ADA_LIBRARY_TYPE=static \
		-P testsuite/test_programs/test_programs.gpr \
		-p \
		-j$(makeopts_jobs) \
		|| die
	gprinstall \
		-XLIBRARY_TYPE=static \
		-XPRETTIER_ADA_LIBRARY_TYPE=static \
		--prefix="${TMP}"/usr \
		--install-name=test_programs \
		--mode=usage \
		-P testsuite/test_programs/test_programs.gpr \
		-p \
		-f \
		|| die
	PATH=${PATH}:"${TMP}"/usr/bin \
	${EPYTHON} testsuite/testsuite.py || die
}
