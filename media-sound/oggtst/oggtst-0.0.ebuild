# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit autotools

DESCRIPTION="A tool for calculating ogg-vorbis playing time"
HOMEPAGE="http://gnometoaster.rulez.org/"
SRC_URI="http://gnometoaster.rulez.org/archive/${PN}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=media-libs/libao-0.8.0
	>=media-libs/libvorbis-1.0_rc2"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# upstream didn't use make dist to create the tarball, there are
	# unbound symlinks inside it.
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README
}
