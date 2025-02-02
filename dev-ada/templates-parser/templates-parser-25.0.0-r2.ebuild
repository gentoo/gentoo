# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_12 gcc_13 gcc_14 )
PYTHON_COMPAT=( python3_{10..13} python3_13t )
inherit ada python-any-r1 multiprocessing

DESCRIPTION="A template engine"
HOMEPAGE="https://github.com/AdaCore/templates-parser"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc man +shared static-libs static-pic test"
RESTRICT="!test? ( test )"

RDEPEND="${ADA_DEPS}
	dev-ada/xmlada[${ADA_USEDEP},shared?,static-libs?,static-pic?]
"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"
BDEPEND="doc? (
	dev-tex/latexmk
	dev-texlive/texlive-latexextra
)
man? (
	dev-python/sphinx
	dev-python/sphinx-rtd-theme
)
test? (
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-ada/e3-testsuite[${PYTHON_USEDEP}]
	')
	dev-ada/gnatmem
)"

REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}
	doc? ( man )
	test? ( static-libs )
"

python_check_deps() {
	use test || return 0
	python_has_version "dev-ada/e3-testsuite[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# Drop tests that require TP_XMLADA
	rm -r regtests/tests/010{7,9}* || die
	default
}

src_configure() {
	cp config/tp_xmlada_dummy.gpr tp_xmlada.gpr
	echo "PRJ_TARGET = Linux" > makefile.setup
	echo "VERSION = $(ver_cut 1-2)" >> makefile.setup
}

src_compile() {
	build() {
		gprbuild -p -v -XPRJ_BUILD=Release -XPRJ_TARGET=Linux \
			-XTP_XMLADA=Disabled -XPROCESSORS=$(makeopts_jobs) \
			-XVERSION=$(ver_cut 1-2) -XLIBRARY_TYPE=$1 -XXMLADA_BUILD=$1 \
			--subdirs=${CHOST}/release/$1 \
			-Ptemplates_parser -largs ${LDFLAGS} -cargs ${ADAFLAGS} \
			|| die "gprbuild failed"
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
	local lib
	if use shared; then
		lib=relocatable
	elif use static-libs; then
		lib=static
	else
		lib=static-pic
	fi
	gprbuild -p -v -XPRJ_BUILD=Release -XPRJ_TARGET=Linux \
		-XTP_XMLADA=Disabled -XPROCESSORS=$(makeopts_jobs) \
		-XVERSION=$(ver_cut 1-2) -XLIBRARY_TYPE=${lib} -XXMLADA_BUILD=${lib} \
		--subdirs=${CHOST}/release/${lib} -Ptools/tools -largs ${LDFLAGS} \
		-cargs ${ADAFLAGS} \
		|| die "gprbuild failed"
	if use man; then
		emake -C docs man GPROPTS=-v
	fi
	if use doc; then
		emake -C docs html epub latexpdf GPROPTS=-v
	fi
}

src_install() {
	build() {
		gprinstall -XPRJ_BUILD=Release -XPRJ_TARGET=Linux \
			-XTP_XMLADA=Disabled -XPROCESSORS=$(makeopts_jobs) \
			-XVERSION=$(ver_cut 1-2) -XLIBRARY_TYPE=$1 -XXMLADA_BUILD=$1 \
			-p -f --prefix="${D}"/usr --build-var=LIBRARY_TYPE \
			--build-var=TEMPLATES_PARSER_BUILD --subdirs=${CHOST}/release/$1 \
			--build-name=$1 -Ptemplates_parser \
			|| die "gprinstall failed"
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
	local lib
	if use shared; then
		lib=relocatable
	elif use static-libs; then
		lib=static
	else
		lib=static-pic
	fi
	gprinstall -XPRJ_BUILD=Release -XPRJ_TARGET=Linux -XTP_XMLADA=Disabled \
		-XPROCESSORS=$(makeopts_jobs) -XVERSION=$(ver_cut 1-2) \
		-XLIBRARY_TYPE=${lib} -XXMLADA_BUILD=${lib} -p -f --prefix="${D}"/usr \
		--build-var=LIBRARY_TYPE --build-var=TEMPLATES_PARSER_BUILD \
		--mode=usage --subdirs=${CHOST}/release/${lib} \
		--install-name=templates_parser -Ptools/tools \
		|| die "gprinstall failed"
	DOCS="README.md"
	if use doc; then
		mv "${D}"/usr/share/doc/templates_parser "${D}"/usr/share/doc/"${PF}" || die
		DOCS+=" docs/build/epub/Templates_ParserTemplatesEngine.epub"
	fi
	einstalldocs
	use man && doman docs/build/man/templates_parser.1
	rm -r "${D}"/usr/share/gpr/manifests
}

src_test() {
	emake -j1 test
}
