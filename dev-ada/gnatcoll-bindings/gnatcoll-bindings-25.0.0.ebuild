# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
ADA_COMPAT=( gcc_13 gcc_14 )
inherit ada multiprocessing python-single-r1

DESCRIPTION="GNAT Component Collection"
HOMEPAGE="https://github.com/AdaCore/gnatcoll-bindings/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 x86"
IUSE="doc gmp lzma openmp +shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	${ADA_DEPS}
	dev-ada/gnatcoll-core:${SLOT}[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	gmp? ( dev-libs/gmp:* )
	lzma? ( app-arch/xz-utils )
	openmp? ( sys-devel/gcc:=[openmp] )
	$(python_gen_cond_dep '
		doc? (
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		)
	')"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

QA_EXECSTACK=usr/lib/gnatcoll_readline.*/libgnatcoll_readline.*

pkg_setup() {
	python-single-r1_pkg_setup
	ada_pkg_setup
}

src_prepare() {
	rm -r python || die
	mv python3 python || die
	default
}

src_compile() {
	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v \
			-XGPR_BUILD=$2 -XGNATCOLL_CORE_BUILD=$2 \
			-XLIBRARY_TYPE=$2 -P $1/gnatcoll_$1.gpr -XBUILD="PROD" \
			-XGNATCOLL_VERSION=${PV} \
			-XGNATCOLL_ICONV_OPT= -XGNATCOLL_PYTHON_CFLAGS="-I$(python_get_includedir)" \
			-XGNATCOLL_PYTHON_LIBS=$(python_get_library_path) \
			-cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} || die "gprbuild failed"
	}
	for kind in shared static-libs static-pic ; do
		if use $kind; then
			lib=${kind%-libs}
			lib=${lib/shared/relocatable}
			build cpp $lib
			build iconv $lib
			use gmp && build gmp $lib
			use lzma && build lzma $lib
			use openmp && build omp $lib
			build python $lib
			build syslog $lib
			build readline $lib
			build zlib $lib
		fi
	done
	if use doc; then
		emake -C iconv/docs html
		emake -C readline/docs html
		emake -C syslog/docs html
		mkdir html
		mv iconv/docs/_build/html html/iconv || die
		mv readline/docs/_build/html html/readline || die
		mv syslog/docs/_build/html html/syslog || die
	fi
}

src_install() {
	build () {
		gprinstall -p -f -XBUILD=PROD --prefix="${D}"/usr -XLIBRARY_TYPE=$2 \
			-XGPR_BUILD=$2 -XGNATCOLL_CORE_BUILD=$2 \
			-XGNATCOLL_VERSION=${PV} --build-var=LIBRARY_TYPE \
			-XGNATCOLL_ICONV_OPT= -P $1/gnatcoll_$1.gpr --build-name=$2
	}
	for kind in shared static-libs static-pic ; do
		if use $kind; then
			lib=${kind%-libs}
			lib=${lib/shared/relocatable}
			build cpp $lib
			use gmp && build gmp $lib
			build iconv $lib
			use lzma && build lzma $lib
			use openmp && build omp $lib
			build python $lib
			build syslog $lib
			build readline $lib
			use lzma && build lzma $lib
			build zlib $lib
		fi
	done
	rm -rf "${D}"/usr/share/gpr/manifests
	use doc && HTML_DOCS=( html/* )
	einstalldocs
}
