# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="Provides a markdown parser written in Ada"
HOMEPAGE="https://github.com/AdaCore/markdown"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${ADA_DEPS}
	dev-ada/gprbuild[${ADA_USEDEP}]
	dev-ada/VSS[${ADA_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND=""

src_compile() {
	gprbuild -v -p -j$(makeopts_jobs) -XBUILD_MODE=dev gnat/markdown.gpr -cargs ${ADAFLAGS}
}
