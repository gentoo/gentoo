# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2

PDOC=VLT-PRO-ESO-19000-1932-V4

DESCRIPTION="ESO astronomical data file organizer"
HOMEPAGE="https://www.eso.org/sci/software/gasgano.html"
SRC_URI="ftp://ftp.eso.org/pub/dfs/${PN}/${P}.tar.gz
	doc? ( https://www.eso.org/sci/software/gasgano/${PDOC}.pdf )"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND="
	>=virtual/jre-1.8:*
	dev-java/gnu-regexp:1
	dev-java/jal:0
	dev-java/junit:0
"

src_prepare() {
	java-pkg-2_src_prepare
	sed -i \
		-e "s:^BASE=\`pwd\`:BASE=${EPREFIX}/usr/share/${PN}:" \
		-e 's:$BASE/share/:$BASE/lib/:g' \
		bin/gasgano || die
}

src_install() {
	dobin bin/*
	java-pkg_dojar share/*.jar
	insinto /usr/share/${PN}
	doins -r config
	make_desktop_entry gasgano "Gasgano FITS Organizer"
	use doc && newdoc "${DISTDIR}"/${PDOC}.pdf user-manual.pdf
}
