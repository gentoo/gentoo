# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == "9999" ]]; then
	inherit mercurial
	EHG_REPO_URI="http://hg.code.sf.net/p/ksokoban/code"
else
	SRC_URI="http://dev.gentoo.org/~bircoph/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

inherit cmake-utils
DESCRIPTION="The japanese warehouse keeper game"
HOMEPAGE="https://sourceforge.net/projects/ksokoban/"
LICENSE="GPL-2"
SLOT="0"

DEPEND="kde-base/kdelibs:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

CMAKE_IN_SOURCE_BUILD="yes"

src_prepare() {
	sed -i 's/%m//' "data/${PN}.desktop" || die "sed for desktop file failed"
}

# source lacks install target
src_install() {
	dobin ksokoban
	dodoc AUTHORS NEWS TODO
	domenu "data/${PN}.desktop"
	for i in 16 22 32 48 64 128; do
		doicon -s "${i}" "data/hi${i}-app-${PN}.png"
	done
}
