# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Protein secondary structure assignment from atomic coordinates"
HOMEPAGE="http://webclu.bio.wzw.tum.de/stride/"
SRC_URI="
	ftp://ftp.ebi.ac.uk/pub/software/unix/${PN}/src/${PN}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${PN}-20060723-update.patch.bz2"

LICENSE="STRIDE"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
RESTRICT="mirror bindist"

S="${WORKDIR}"
PATCHES=(
	# this patch updates the source to the most recent
	# version which was kindly provided by the author
	"${S}"/${PN}-20060723-update.patch
	"${FILESDIR}"/${PN}-20011129-fix-buildsystem.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}
}
