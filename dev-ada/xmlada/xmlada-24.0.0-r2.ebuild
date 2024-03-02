# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="Set of modules that provide a simple manipulation of XML streams"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc +shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"
BDEPEND="doc? (
	dev-tex/latexmk
	dev-python/sphinx
	dev-python/sphinx-rtd-theme
	dev-texlive/texlive-latexextra
)"

PATCHES=(
	"${FILESDIR}"/${PN}-23.0.0-gentoo.patch
	"${FILESDIR}"/${P}-gentoo.patch
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
		emake -C docs latexpdf
		emake -C docs html
	fi
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

	einstalldocs
	dodoc xmlada-roadmap.txt
	rm -rf "${D}"/usr/share/gpr/manifests
}
