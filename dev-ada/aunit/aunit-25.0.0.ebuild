# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="Ada unit testing framework"
HOMEPAGE="https://github.com/AdaCore/aunit"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"
BDEPEND="doc? (
	dev-tex/latexmk
	dev-texlive/texlive-latexextra
	dev-python/sphinx
	dev-python/sphinx-rtd-theme
)"

REQUIRED_USE="${ADA_REQUIRED_USE}"

src_prepare() {
	default
	sed -i \
		-e "s|@PF@|${PF}|g" \
		lib/gnat/aunit.gpr \
		|| die
}

src_compile() {
	emake GPROPTS_EXTRA="-j$(makeopts_jobs) -v -cargs ${ADAFLAGS}"
	use doc && emake -C doc all
}

src_install() {
	emake INSTALL="${D}"/usr install
	DOCS="README"
	if use doc; then
		DOCS+=" doc/build/aunit_cb/pdf/aunit_cb.pdf"
		DOCS+=" doc/build/aunit_cb/txt/aunit_cb.txt"
		HTML_DOCS="doc/build/aunit_cb/html"
	fi
	einstalldocs
	if use doc; then
		insinto /usr/share/info
		doins doc/build/aunit_cb/info/aunit_cb.info
		docompress -x /usr/share/info
	fi
	mv "${D}"/usr/share/examples "${D}"/usr/share/doc/${PF}/
	rm -r "${D}"/usr/share/gpr/manifests || die
}

src_test() {
	emake PROJECT_PATH_ARG="ADA_PROJECT_PATH=$(pwd)/lib/gnat" -C test
}
