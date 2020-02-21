# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A tool for calculating ogg-vorbis playing time"
HOMEPAGE="http://gnometoaster.rulez.org/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ppc ppc64 sparc x86"

RDEPEND="
	media-libs/libao:=
	media-libs/libvorbis:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	mv configure.{in,ac} || die
	# upstream didn't use make dist to create the tarball,
	# there are unbound symlinks inside it.
	eautoreconf
}
