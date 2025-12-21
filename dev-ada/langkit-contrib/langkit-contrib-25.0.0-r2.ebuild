# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
ADA_COMPAT=( gcc_{12..16} )

DISTUTILS_USE_PEP517=setuptools
inherit python-single-r1 ada multiprocessing

DESCRIPTION="A Python framework to generate language parsers - Contrib"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="https://github.com/AdaCore/langkit/archive/refs/tags/v${PV}.tar.gz
	-> langkit-${PV}.tar.gz
	https://github.com/AdaCore/AdaSAT/archive/refs/tags/v${PV}.tar.gz
	-> AdaSAT-${PV}.tar.gz"

S="${WORKDIR}"/langkit-${PV}

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 x86"
IUSE="static-libs static-pic"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	${ADA_DEPS}
	dev-ada/langkit:${SLOT}[${ADA_USEDEP},static-libs?,static-pic?]
	$(python_gen_cond_dep '
		dev-ada/langkit[${PYTHON_USEDEP}]
	')"
BDEPEND="${RDEPEND}
	dev-ada/e3-core
	$(python_gen_cond_dep '
		dev-ada/e3-core[${PYTHON_USEDEP}]
	')
	dev-ada/gprbuild[${ADA_USEDEP}]"

pkg_setup() {
	python-single-r1_pkg_setup
	ada_pkg_setup
}

src_configure() {
	export GPR_PROJECT_PATH="${WORKDIR}"/AdaSAT-${PV}
	cd contrib/python || die
	${EPYTHON} manage.py generate -P --disable-warning undocumented-nodes || die
	cd ../lkt || die
	${EPYTHON} manage.py generate -P || die
}

src_compile() {
	cd contrib/python
	build () {
		rm -f build/obj/dev/*.lexch
		gprbuild -v -p -j$(makeopts_jobs) -Pbuild/libpythonlang.gpr \
			-XLIBRARY_TYPE=$1 -XGPR_BUILD=$1 -XXMLADA_BUILD=$1 \
			-XLIBPYTHONLANG_WARNINGS=true -gnatef \
			-cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprbuild -v -p -j$(makeopts_jobs) -Pbuild/mains.gpr \
		-XLIBRARY_TYPE=relocatable -XGPR_BUILD=relocatable \
		-XXMLADA_BUILD=relocatable -XLIBPYTHONLANG_WARNINGS=true \
		parse.adb -gnatef -cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} \
		|| die
	cd ../lkt
	build () {
		rm -f build/obj/dev/*.lexch
		gprbuild -v -p -j$(makeopts_jobs) -Pbuild/liblktlang.gpr \
			-XLIBRARY_TYPE=$1 -XGPR_BUILD=$1 -XXMLADA_BUILD=$1 \
			-XLIBLKTLANG_WARNINGS=true -gnatef \
			-cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprbuild -v -p -j$(makeopts_jobs) -Pbuild/mains.gpr \
		-XLIBRARY_TYPE=relocatable -XGPR_BUILD=relocatable \
		-XXMLADA_BUILD=relocatable -XLIBLKTLANG_WARNINGS=true \
		parse.adb lkt_toolbox.adb unparse.adb -gnatef \
		-cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} || die
	cd ../..
}

src_install() {
	cd contrib/python
	build () {
		gprinstall -v -p -Pbuild/libpythonlang.gpr --prefix="${D}"/usr \
			--build-var=LIBRARY_TYPE --build-var=LIBPYTHONLANG_LIBRARY_TYPE \
			--sources-subdir=include/libpythonlang --build-name=$1 \
			-XLIBRARY_TYPE=$1 -XGPR_BUILD=$1 -XXMLADA_BUILD=$1 || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	python_domodule build/python/libpythonlang
	cd ../lkt
	build () {
		gprinstall -v -p -Pbuild/liblktlang.gpr --prefix="${D}"/usr \
			--build-var=LIBRARY_TYPE --build-var=LIBLKTLANG_LIBRARY_TYPE \
			--sources-subdir=include/liblktlang --build-name=$1 \
			-XLIBRARY_TYPE=$1 -XGPR_BUILD=$1 -XXMLADA_BUILD=$1 || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	python_domodule build/python/liblktlang
}
