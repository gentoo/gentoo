# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_{12..16} )
PYTHON_COMPAT=( python3_{10..14} )
inherit ada python-any-r1 multiprocessing

DESCRIPTION="Ada unit testing framework"
HOMEPAGE="https://github.com/AdaCore/aunit"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc"
REQUIRED_USE="${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"
BDEPEND="doc? (
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	')
)"

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
	ada_pkg_setup
}

src_prepare() {
	default
	sed -i \
		-e "s|@PF@|${PF}|g" \
		lib/gnat/aunit.gpr \
		|| die
}

src_compile() {
	emake GPROPTS_EXTRA="-j$(makeopts_jobs) -v -cargs ${ADAFLAGS}"
	use doc && emake -C doc aunit_cb.html
}

src_install() {
	emake INSTALL="${D}"/usr install
	DOCS="README"
	use doc && HTML_DOCS="doc/build/aunit_cb/html/*"
	einstalldocs
	mv "${D}"/usr/share/examples "${D}"/usr/share/doc/${PF}/
	rm -r "${D}"/usr/share/gpr/manifests || die
}

src_test() {
	emake PROJECT_PATH_ARG="ADA_PROJECT_PATH=$(pwd)/lib/gnat" -C test
}
