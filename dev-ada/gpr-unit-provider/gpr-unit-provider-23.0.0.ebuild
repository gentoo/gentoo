# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_2021 gcc_12_2_0 )
inherit ada multiprocessing

DESCRIPTION="GPR Unit Provider"
HOMEPAGE="https://github.com/AdaCore/gpr-unit-provider"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${ADA_DEPS}
	dev-ada/gpr[${ADA_USEDEP},shared?]
	dev-ada/libadalang[${ADA_USEDEP},static-libs]
	shared? ( dev-ada/libadalang[static-pic] )"
DEPEND="${RDEPEND}"
BDEPEND=""

IUSE="+shared"
REQUIRED_USE="${ADA_REQUIRED_USE}"

src_compile() {
	emake PROCESSORS=$(makeopts_jobs) \
		ENABLE_SHARED=$(usex shared) \
		GPRBUILD_OPTIONS=-v
}

src_install() {
	emake ENABLE_SHARED=$(usex shared) \
		prefix="${D}"/usr \
		install
	einstalldocs
}
