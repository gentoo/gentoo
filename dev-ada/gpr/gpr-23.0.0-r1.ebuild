# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_2021 gcc_12_2_0 )
PYTHON_COMPAT=( python3_{9,10,11} )

inherit python-any-r1 ada multiprocessing

DESCRIPTION="LibGPR2 - Parser for GPR Project files"
HOMEPAGE="https://github.com/AdaCore/gpr"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${ADA_DEPS}
	dev-ada/xmlada[${ADA_USEDEP}]
	shared? ( dev-ada/xmlada[shared,static-pic] )
	dev-ada/gnatcoll-core[${ADA_USEDEP}]
	shared? ( dev-ada/gnatcoll-core[shared,static-pic] )
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},iconv,gmp]
	shared? ( dev-ada/gnatcoll-bindings[shared,static-pic] )"

DEPEND="${RDEPEND}
	dev-ada/gprconfig_kb[${ADA_USEDEP}]
	dev-ada/gprbuild[${ADA_USEDEP}]"

BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-ada/langkit[${PYTHON_USEDEP}]
	')"

IUSE="+shared"
REQUIRED_USE="${ADA_REQUIRED_USE}"

python_check_deps() {
	python_has_version "dev-ada/langkit[${PYTHON_USEDEP}]"
}

src_configure() {
	emake PROCESSORS=$(makeopts_jobs) \
		GPR2KBDIR=/usr/share/gprconfig \
		ENABLE_SHARED=$(usex shared) \
		setup
}

src_compile() {
	emake GPRBUILD_OPTIONS=-v
}

src_install() {
	emake install \
		prefix="${D}"/usr
	einstalldocs

	rm "${D}"/usr/bin/gprclean || die
	rm "${D}"/usr/bin/gprconfig || die
	rm "${D}"/usr/bin/gprinstall || die
	rm "${D}"/usr/bin/gprls || die
	rm "${D}"/usr/bin/gprname || die
}
