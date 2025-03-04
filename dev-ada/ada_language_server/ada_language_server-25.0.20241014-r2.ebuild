# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_14 )
inherit ada multiprocessing

DESCRIPTION="a Language Server Protocol for Ada/SPARK"
HOMEPAGE="https://github.com/AdaCore/ada_language_server"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test" # Tests do not work

RDEPEND="${ADA_DEPS}
	dev-ada/ada_libfswatch:=[${ADA_USEDEP}]
	dev-ada/AdaSAT:=[${ADA_USEDEP}]
	dev-ada/gnatcoll-bindings:=[${ADA_USEDEP},shared]
	dev-ada/gnatcoll-core:=[${ADA_USEDEP},shared]
	dev-ada/gnatdoc:=[${ADA_USEDEP}]
	dev-ada/gnatformat:=[${ADA_USEDEP}]
	dev-ada/gpr:=[${ADA_USEDEP}]
	dev-ada/lal-refactor:=[${ADA_USEDEP},shared(+)]
	dev-ada/langkit:=[${ADA_USEDEP},shared(+)]
	dev-ada/libadalang:=[${ADA_USEDEP}]
	>=dev-ada/libadalang-tools-23:=[${ADA_USEDEP},shared]
	dev-ada/libgpr:=[${ADA_USEDEP}]
	dev-ada/prettier-ada:=[${ADA_USEDEP}]
	dev-ada/spawn:=[${ADA_USEDEP},shared]
	dev-ada/templates-parser:=[${ADA_USEDEP},shared]
	>=dev-ada/VSS-25.0.0:=[${ADA_USEDEP},shared]
	dev-ada/xmlada:=[${ADA_USEDEP},shared]
	dev-libs/gmp
	sys-fs/fswatch:="
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]
	test? ( dev-ada/e3-testsuite )"

REQUIRED_USE="${ADA_REQUIRED_USE}"

src_compile() {
	gprbuild -v -m -j$(makeopts_jobs) -P gnat/lsp_server.gpr -p \
		-XLIBRARY_TYPE=relocatable -XXMLADA_BUILD=relocatable \
		-XGPR_BUILD=relocatable -cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} \
		|| die
	gprbuild -v -m -j$(makeopts_jobs) -P gnat/lsp_3_17.gpr -p \
		-XLIBRARY_TYPE=relocatable -XXMLADA_BUILD=relocatable \
		-XGPR_BUILD=relocatable -cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} \
		|| die
	gprbuild -v -m -j$(makeopts_jobs) -P gnat/tester.gpr -p \
		-XLIBRARY_TYPE=relocatable -XXMLADA_BUILD=relocatable \
		-XGPR_BUILD=relocatable -cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} \
		|| die
	gprbuild -v -m -j$(makeopts_jobs) -P gnat/lsp_client.gpr -p \
		-XLIBRARY_TYPE=relocatable -XXMLADA_BUILD=relocatable \
		-XGPR_BUILD=relocatable -cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} \
		|| die
	mkdir -p integration/vscode/ada/x64/linux
	cp -f .obj/server/ada_language_server integration/vscode/ada/x64/linux || die
}

src_install() {
	gprinstall -v -f -P gnat/lsp_server.gpr -p -r --mode=usage \
		--prefix="${D}"/usr -XLIBRARY_TYPE=relocatable \
		-XXMLADA_BUILD=relocatable -XGPR_BUILD=relocatable || die
	gprinstall -v -f -P gnat/tester.gpr -p --prefix="${D}"/usr \
		-XLIBRARY_TYPE=relocatable -XXMLADA_BUILD=relocatable \
		-XGPR_BUILD=relocatable || die
	gprinstall -v -f -P gnat/lsp_client.gpr -p -r --mode=dev \
		--prefix="${D}"/usr -XLIBRARY_TYPE=relocatable \
		-XXMLADA_BUILD=relocatable -XGPR_BUILD=relocatable || die
	rm "${D}"/usr/share/gpr/gnatcoll.gpr || die
	einstalldocs
}
