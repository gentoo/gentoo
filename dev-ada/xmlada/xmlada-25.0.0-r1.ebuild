# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 gcc_14 )
inherit ada multiprocessing

DESCRIPTION="Set of modules that provide a simple manipulation of XML streams"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc man +shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}
	doc? ( man )"

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"
BDEPEND="doc? (
	dev-tex/latexmk
	dev-texlive/texlive-latexextra
)
man? (
	dev-python/sphinx
	dev-python/sphinx-rtd-theme
)"

PATCHES=(
	"${FILESDIR}"/${PN}-23.0.0-gentoo.patch
	"${FILESDIR}"/${PN}-24.0.0-gentoo.patch
)

src_prepare() {
	default
	sed -i \
		-e "s|@PF@|${PF}|g" \
		input_sources/xmlada_input.gpr \
		|| die
}

src_compile() {
	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=$1 \
			-XBUILD=Production -XPROCESSORS=$(makeopts_jobs) xmlada.gpr \
			-largs ${LDFLAGS} \
			-cargs ${ADAFLAGS} || die "gprbuild failed"
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
	if use doc; then
		emake -C docs html
		emake -C docs epub
		emake -C docs latexpdf
	fi
	use man && emake -C docs man
}

src_test() {
	GPR_PROJECT_PATH=schema:input_sources:dom:sax:unicode \
	gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=static \
		-XBUILD=Production -XPROCESSORS=$(makeopts_jobs) xmlada.gpr \
		-XTESTS_ACTIVATED=Only \
		-largs ${LDFLAGS} \
		-cargs ${ADAFLAGS} || die "gprbuild failed"
	emake --no-print-directory -C tests tests | tee xmlada.testLog
	grep -q DIFF xmlada.testLog && die
	rm docs/*/b__* || die
	rm docs/*/*ali || die
	rm docs/*/*std* || die
	rm docs/*/*bexch || die
	rm docs/*/*.o || die
	rm docs/*/*example || die
	rm docs/dom/domexample2 || die
	rm docs/sax/saxexample_main || die
}

src_install() {
	build () {
		gprinstall -XLIBRARY_TYPE=$1 -f -p -XBUILD=Production \
			-XPROCESSORS=$(makeopts_jobs) --prefix="${D}"/usr \
			--install-name=xmlada --build-var=LIBRARY_TYPE \
			--build-var=XMLADA_BUILD \
			--build-name=$1 xmlada.gpr || die "gprinstall failed"
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
	DOCS="AUTHORS README.md TODO xmlada-roadmap.txt"
	if use doc; then
		DOCS+=" docs/_build/epub/XMLAdatheXMLLibraryforAda.epub"
	fi
	einstalldocs
	use man && doman docs/_build/man/xmlada.1
	rm -r "${D}"/usr/share/gpr/manifests
}
