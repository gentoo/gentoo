# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A GNU Netlist Manipulation Library"
HOMEPAGE="https://sourceforge.net/projects/gnetman/"
#snapshot from http://gnetman.git.sourceforge.net/git/gitweb.cgi?p=gnetman/gnetman;
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="
	>=dev-lang/tcl-8.6:0
	sci-electronics/geda"
DEPEND="${RDEPEND}
	dev-db/datadraw"

S="${WORKDIR}/${P}/src/batch"
PATCHES=(
	# fix build issues with tcl-8.6, #452034
	"${FILESDIR}"/${P}-tcl86.patch
	# fix build system, #711354
	"${FILESDIR}"/${P}-build-system.patch
	# fix -fno-common, #707894
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	cd ../.. || die
	default
}

src_configure() {
	tc-export CC
	default
}

src_install() {
	cd ../.. || die

	dobin bin/${PN}

	insinto /usr/share/gEDA
	doins system-gnetmanrc.tcl

	use examples && dodoc -r sym sch test
	dodoc README
	use doc && dodoc doc/*.{html,jpg}
}
