# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ADA_COMPAT=( gcc_13 gcc_14 )
PYTHON_COMPAT=( python3_{10..13} )
inherit ada python-any-r1 multiprocessing

DESCRIPTION="GNAT Component Collection Core packages"
HOMEPAGE="https://github.com/AdaCore/gnatcoll-core/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc minimal +projects +shared static-libs static-pic test"
RESTRICT="test"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}
	projects? ( !minimal )"

RDEPEND="
	projects? ( ~dev-ada/libgpr-${PV}:=[${ADA_USEDEP},shared?,static-libs?,static-pic?] )
"
BDEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]
	$(python_gen_any_dep '
		test? ( dev-ada/e3-testsuite[${PYTHON_USEDEP}] )
		doc? (
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		)
	')"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

python_check_deps() {
	if use doc && use test ; then
		python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]" &&
		python_has_version "dev-ada/e3-testsuite[${PYTHON_USEDEP}]" || return 1

		return 0
	elif use test; then
		python_has_version "dev-ada/e3-testsuite[${PYTHON_USEDEP}]" || return 1

		return 0
	elif use doc; then
		python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]" || return 1
	fi

	return 0
}

pkg_setup() {
	if use doc || use test; then
		python-any-r1_pkg_setup
	fi
	ada_pkg_setup
}

src_prepare() {
	default
	sed -i \
		-e "s:@GNATLS@:${GNATLS}:g" \
		projects/src/gnatcoll-projects.ads \
		|| die
	rm -r testsuite/tests/file_indexes || die
	rm -r testsuite/tests/vfs/basic || die
	rm -r testsuite/tests/os/fsutil/sync_trees/error || die
	rm -r testsuite/tests/os/process/priority_unix || die
}

src_compile() {
	export GPR_PROJECT_PATH=minimal:core
	build() {
		gprbuild -v -p -m -P$2/gnatcoll_$2.gpr -j$(makeopts_jobs) \
			-XGNATCOLL_VERSION=$(ver_cut 1-2) -XLIBRARY_TYPE=$1 \
			-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} || die
	}
	buildAll () {
		build $1 minimal
		use minimal && return
		build $1 core
		use projects && build $1 projects
	}
	if use shared; then
		buildAll relocatable
	fi
	if use static-libs; then
		buildAll static
	fi
	if use static-pic; then
		buildAll static-pic
	fi
	use doc && emake -C docs html
}

src_test() {
	#To be run after installation
	cd testsuite
	./run-tests || die
}

src_install() {
	export GPR_PROJECT_PATH=minimal:core
	build() {
		gprinstall -v -P$2/gnatcoll_$2.gpr -XGNATCOLL_VERSION=$(ver_cut 1-2) \
			-p -f --prefix="${D}"/usr --sources-subdir=include/gnatcoll_$2 \
			-XLIBRARY_TYPE=$1 --build-name=$1 --build-var=LIBRARY_TYPE || die
	}
	buildAll () {
		build $1 minimal
		use minimal && return
		build $1 core
		use projects && build $1 projects
	}
	if use shared; then
		buildAll relocatable
	fi
	if use static-libs; then
		buildAll static
	fi
	if use static-pic; then
		buildAll static-pic
	fi
	insinto /usr/share/gpr
	doins gnatcoll.gpr
	use doc && HTML_DOCS=( docs/_build/html/* )
	einstalldocs
	rm -r "${D}"/usr/share/gpr/manifests
}
