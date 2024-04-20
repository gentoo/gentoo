# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-opt-2 java-ant-2 toolchain-funcs

MY_P=${PN}.${PV}

DESCRIPTION="Protein multiple-alignment-based sequence annealing"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://baboon.math.berkeley.edu/${PN}/download/${MY_P}.tar.gz"
S="${WORKDIR}/${PN}-align"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="java"

RDEPEND="java? ( >=virtual/jre-1.8:* )"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-includes.patch
)

src_prepare() {
	default
	java-pkg-opt-2_src_prepare
}

src_configure() {
	tc-export CXX
}

src_compile() {
	emake -C align

	if use java; then
		pushd display >/dev/null || die
		eant -Ddisplay all || die
		popd >/dev/null || die
	fi
}

src_install() {
	dobin align/${PN}

	dodoc align/{README,PROBCONS.README}

	insinto /usr/share/${PN}
	doins -r examples

	if use java; then
		java-pkg_newjar display/AmapDisplay.jar amapdisplay.jar
		java-pkg_dolauncher amapdisplay --jar amapdisplay.jar
	fi
}
