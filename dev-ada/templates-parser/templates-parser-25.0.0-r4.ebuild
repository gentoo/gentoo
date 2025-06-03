# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_{12..15} )
PYTHON_COMPAT=( python3_{11..13} )
inherit ada python-any-r1 multiprocessing

DESCRIPTION="A template engine"
HOMEPAGE="https://github.com/AdaCore/templates-parser"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="doc man static-libs static-pic test"
RESTRICT="!test? ( test )"

RDEPEND="${ADA_DEPS}
	dev-ada/xmlada[${ADA_USEDEP},shared,static-libs?,static-pic?]
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
)"

REQUIRED_USE="
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
			-XPROCESSORS=$(makeopts_jobs) \
			-XVERSION=$(ver_cut 1-2) -XLIBRARY_TYPE=$1 -XXMLADA_BUILD=$1 \
			--subdirs=${CHOST}/release/$1 \
			-Ptemplates_parser -largs ${LDFLAGS} -cargs ${ADAFLAGS} \
			|| die "gprbuild failed"
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprbuild -p -v -XPRJ_BUILD=Release -XPRJ_TARGET=Linux \
		-XPROCESSORS=$(makeopts_jobs) \
		-XVERSION=$(ver_cut 1-2) -XLIBRARY_TYPE=relocatable \
		-XXMLADA_BUILD=relocatable \
		--subdirs=${CHOST}/release/relocatable -Ptools/tools \
		-largs ${LDFLAGS} -cargs ${ADAFLAGS} \
		|| die "gprbuild failed"
	use man && emake -C docs man GPROPTS=-v
	use doc && emake -C docs html epub latexpdf GPROPTS=-v
	if use test; then
		cd regtests
		gprbuild -p -v -XPRJ_BUILD=Release -XPRJ_TARGET=Linux \
			-XPROCESSORS=$(makeopts_jobs) \
			-XVERSION=$(ver_cut 1-2) -XLIBRARY_TYPE=relocatable \
			--subdirs=${CHOST}/release/relocatable \
			-Pregtests -largs ${LDFLAGS} -cargs ${ADAFLAGS} \
			|| die "gprbuild failed"
		cd ..
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
		build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprinstall -XPRJ_BUILD=Release -XPRJ_TARGET=Linux -XTP_XMLADA=Disabled \
		-XPROCESSORS=$(makeopts_jobs) -XVERSION=$(ver_cut 1-2) \
		-XLIBRARY_TYPE=relocatable -XXMLADA_BUILD=relocatable -p -f \
		--prefix="${D}"/usr \
		--build-var=LIBRARY_TYPE --build-var=TEMPLATES_PARSER_BUILD \
		--mode=usage --subdirs=${CHOST}/release/relocatable \
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
	cd regtests
	ADA_PROJECT_PATH="${S}" \
		PRJ_TARGET=Linux \
		PRJ_BUILD=Release \
		TP_XMLADA=Disabled \
		PATH=".:${S}/.build/rbin/${CHOST}/release/relocatable:${S}/.build/bin/${CHOST}/release/relocatable:${PATH}" \
		./testsuite.py || die
	cd ..
}
