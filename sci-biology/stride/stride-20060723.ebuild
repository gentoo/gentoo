# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="Protein secondary structure assignment from atomic coordinates"
HOMEPAGE="http://webclu.bio.wzw.tum.de/stride/"
# Version 20030408 per dates in upstream tarball
UPSTREAM_VER="20030408"
SRC_URI="https://webclu.bio.wzw.tum.de/stride/${PN}.tar.gz -> ${PN}-${UPSTREAM_VER}.tar.gz
	https://dev.gentoo.org/~pacho/${PN}/${PN}-20060723-update-r1.patch.xz"

LICENSE="STRIDE"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
RESTRICT="mirror bindist"

S="${WORKDIR}"
PATCHES=(
	# This patch updates the source to the most recent
	# version which was kindly provided by the author
	"${S}"/${P}-update-r1.patch

	"${FILESDIR}"/${PN}-20011129-fix-buildsystem.patch
	"${FILESDIR}"/${PN}-20011129-clang16.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}
}
