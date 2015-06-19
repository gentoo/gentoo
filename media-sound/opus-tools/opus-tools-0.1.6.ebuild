# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/opus-tools/opus-tools-0.1.6.ebuild,v 1.3 2014/01/22 10:47:42 nimiux Exp $

EAPI=4

if [[ ${PV} == *9999 ]] ; then
	SCM="git-2"
	EGIT_REPO_URI="git://git.opus-codec.org/${PN}.git"
fi

inherit autotools ${SCM}

DESCRIPTION="The Opus codec is designed for interactive speech and audio
transmission over the Internet."
HOMEPAGE="http://opus-codec.org/"
if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
elif [[ ${PV%_p*} != ${PV} ]] ; then # Gentoo snapshot
	SRC_URI="http://dev.gentoo.org/~lu_zero/${PN}/${P}.tar.xz"
else # Official release
	SRC_URI="http://downloads.xiph.org/releases/opus/${P}.tar.gz"
fi

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/libogg-1.3.0
		 >=media-libs/opus-0.9.10"
DEPEND="virtual/pkgconfig
		${DEPEND}"

src_prepare() {
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_compile() {
	default
}

src_install() {
	default
	find "${D}" -name '*.la' -delete
}
