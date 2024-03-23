# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="Ada unit testing framework"
HOMEPAGE="http://libre.adacore.com/tools/aunit/"
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
	dev-python/sphinx
	dev-python/sphinx-rtd-theme
)"

REQUIRED_USE="${ADA_REQUIRED_USE}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	sed -i \
		-e "s|@PF@|${PF}|g" \
		lib/gnat/aunit.gpr \
		|| die
}

src_compile() {
	emake GPROPTS_EXTRA="-j$(makeopts_jobs) -v -cargs ${ADAFLAGS}"
	if use doc; then
		emake -C doc html-all
		emake -C doc txt-all
	fi
}

src_install() {
	emake INSTALL="${D}"/usr install
	einstalldocs
	rm -r "${D}"/usr/share/gpr/manifests || die
}

src_test() {
	emake PROJECT_PATH_ARG="ADA_PROJECT_PATH=$(pwd)/lib/gnat" -C test
}
