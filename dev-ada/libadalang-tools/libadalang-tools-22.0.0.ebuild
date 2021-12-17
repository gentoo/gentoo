# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_202{0,1} )
inherit ada multiprocessing

DESCRIPTION="Libadalang-based tools: gnatpp, gnatmetric and gnatstub"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/libadalang[${ADA_USEDEP},static-libs]"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"

src_compile() {
	gprbuild -v -k -XLIBRARY_TYPE=static -XXMLADA_BUILD=static \
		-XBUILD_MODE=dev -XLALTOOLS_SET=all -P src/build.gpr -p \
		-j$(makeopts_jobs) || die
}

src_install() {
	dobin bin/gnat{metric,pp,stub,test}
	einstalldocs
}
