# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

DESCRIPTION="Sound Description Interchange Format Library for audio and wave processing"
HOMEPAGE="https://sourceforge.net/projects/sdif/"
SRC_URI="https://sourceforge.net/projects/sdif/files/sdif/SDIF-${PV}/SDIF-${PV}-src.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug ftruncate threads"

PATCHES=(
	"${FILESDIR}/${P}-fix-buildsystem.patch"
)
S="${WORKDIR}/SDIF-${PV}-src"

src_prepare() {
	mv configure.{in,ac} || die
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable ftruncate) \
		$(use_enable threads pthreads)
}

src_install() {
	default
	prune_libtool_files --all
}
