# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
PYTHON_COMPAT=( python3_{9,10,11} )

inherit python-any-r1 ada multiprocessing

DESCRIPTION="LibGPR2 - Parser for GPR Project files"
HOMEPAGE="https://github.com/AdaCore/gpr"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}
	dev-ada/xmlada[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	dev-ada/gnatcoll-core[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},shared?,static-libs?,static-pic?,iconv,gmp]
"

DEPEND="${RDEPEND}
	dev-ada/gprconfig_kb[${ADA_USEDEP}]
	dev-ada/gprbuild[${ADA_USEDEP}]"

BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-ada/langkit[${PYTHON_USEDEP}]
	')
	dev-ada/libadalang
"

python_check_deps() {
	python_has_version "dev-ada/langkit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	ada_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	emake ENABLE_SHARED=$(usex shared) setup
}

src_compile() {
	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=$1 \
			-XGPR2_BUILD=release -XXMLADA_BUILD=$1 gpr2.gpr \
			-largs ${LDFLAGS} \
			-cargs ${ADAFLAGS} || die "gprbuild failed"
	}
	mkdir -p .build/kb || die
	gprbuild -p -v -P src/kb/collect_kb.gpr -XKB_BUILD_DIR=.build/kb \
		--relocate-build-tree -largs ${LDFLAGS} -cargs ${ADAFLAGS} || die
	.build/kb/collect_kb -o .build/kb/config.kb /usr/share/gprconfig || die
	emake -C langkit setup DEST="${S}/.build/lkparser" PYTHONEXE=${PYTHON}
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

	gprbuild -p -m -v -j$(makeopts_jobs) -XGPR2_BUILD=release \
		-XLIBRARY_TYPE=${libtype} -XXMLADA_BUILD=${libtype} gpr2-tools.gpr \
		-largs ${LDFLAGS} -cargs ${ADAFLAGS} || die
	gprbuild -p -m -v -j$(makeopts_jobs) -XGPR2_BUILD=release \
		-XLIBRARY_TYPE=${libtype} -XXMLADA_BUILD=${libtype} \
		-XLANGKIT_SUPPORT_BUILD=${libtype} gpr2-name.gpr \
		-largs ${LDFLAGS} -cargs ${ADAFLAGS} || die
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
	gprinstall -p -f -v -XGPR2_BUILD=release --prefix="${D}/usr" \
		-XLIBRARY_TYPE=${libtype} -XXMLADA_BUILD=${libtype} \
		--build-name=${libtype} --mode=usage gpr2-tools.gpr || die
	gprinstall -p -f -v -XGPR2_BUILD=release --prefix='${D}/usr' \
		-XLIBRARY_TYPE=${libtype} -XXMLADA_BUILD=${libtype} \
		-XLANGKIT_SUPPORT_BUILD=${libtype} --build-name=${libtype} \
		--mode=usage gpr2-name.gpr || die

	einstalldocs

	rm "${D}"/usr/bin/gprclean || die
	rm "${D}"/usr/bin/gprconfig || die
	rm "${D}"/usr/bin/gprinstall || die
	rm "${D}"/usr/bin/gprls || die
}
