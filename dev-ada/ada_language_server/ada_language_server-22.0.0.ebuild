# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_202{0,1} gcc_12_2_0 )
inherit ada multiprocessing

DESCRIPTION="an implementation of the Microsoft Language Server Protocol for Ada/SPARK"
HOMEPAGE="https://github.com/AdaCore/ada_language_server"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"
IUSE="test"
RESTRICT="!test? ( test )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${ADA_DEPS}
	dev-ada/ada_libfswatch[${ADA_USEDEP}]
	dev-ada/gnatcoll-core[${ADA_USEDEP},shared]
	dev-ada/libadalang[${ADA_USEDEP}]
	dev-ada/libadalang-tools[${ADA_USEDEP},shared]
	dev-ada/spawn[${ADA_USEDEP},shared,glib]
	dev-ada/VSS[${ADA_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]
	test? ( dev-ada/e3-testsuite )"

REQUIRED_USE="${ADA_REQUIRED_USE}"

src_compile() {
	gprbuild -v -j$(makeopts_jobs) -P gnat/tester.gpr -p \
		-XLIBRARY_TYPE=relocatable \
		-XBUILD_MODE=prod \
		-cargs:Ada ${ADAFLAGS} || die
	gprbuild -v -j$(makeopts_jobs) -c -u -P gnat/lsp_server.gpr -p \
		-XLIBRARY_TYPE=relocatable s-memory.adb \
		-XBUILD_MODE=prod \
		-cargs:Ada ${ADAFLAGS} || die
	gprbuild -v -j$(makeopts_jobs) -P gnat/lsp_server.gpr -p \
		-XLIBRARY_TYPE=relocatable -XVERSION= \
		-XBUILD_MODE=prod \
		-cargs:Ada ${ADAFLAGS} || die
	gprbuild -v -j$(makeopts_jobs) -P gnat/codec_test.gpr -p \
		-XLIBRARY_TYPE=relocatable \
		-XBUILD_MODE=prod \
		-cargs:Ada ${ADAFLAGS} || die
	gprbuild -v -j$(makeopts_jobs) -P gnat/lsp_client.gpr -p \
		-XLIBRARY_TYPE=relocatable \
		-XBUILD_MODE=prod \
		-cargs:Ada ${ADAFLAGS} || die
	gprbuild -v -j$(makeopts_jobs) -P gnat/lsp_client_glib.gpr -p \
		-XLIBRARY_TYPE=relocatable \
		-XBUILD_MODE=prod \
		-cargs:Ada ${ADAFLAGS} || die
	mkdir -p integration/vscode/ada/linux
	cp -f .obj/server/ada_language_server integration/vscode/ada/linux || die
}

src_install() {
	emake install DESTDIR="${D}"/usr
	gprinstall -f -P gnat/lsp_client_glib.gpr -p -r	--mode=dev \
		--prefix="${D}"/usr -XBUILD_MODE=dev -XLIBRARY_TYPE=relocatable || die

	einstalldocs
}
