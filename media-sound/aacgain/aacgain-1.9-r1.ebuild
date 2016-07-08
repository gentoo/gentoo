# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils autotools

FAAD2_PV="2.7"
MP4V2_PV="1.9.1"
MP3GAIN_PV="1.5.2"

DESCRIPTION="AACGain normalizes the volume of digital music files using the Replay Gain algorithm"
HOMEPAGE="http://aacgain.altosdesign.com/"
SRC_URI="http://sbriesen.de/gentoo/distfiles/${P}.tar.xz
	https://mp4v2.googlecode.com/files/mp4v2-${MP4V2_PV}.tar.bz2
	mirror://sourceforge/mp3gain/mp3gain-${MP3GAIN_PV//./_}-src.zip
	mirror://sourceforge/faac/faad2-${FAAD2_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

DOCS="${PN}/README"

src_unpack() {
	mkdir -p "${S}"
	for X in ${A}; do
		case "${X}" in
			mp3gain*)
				mkdir -p "${S}/${X%%-*}"
				cd "${S}/${X%%-*}"
				unpack "${X}"
				;;
			*)
				cd "${S}"
				unpack "${X}"
				[ -d "${X%%-*}" ] || mv -f "${X%%-*}"-* "${X%%-*}"
				;;
		esac
	done
}

PATCHES=(
	${PN}/mp4v2.patch
	"${FILESDIR}"/${P}-patch-dotdot.patch
)

src_prepare() {
	default

	sed -i -e 's:iquote :I:' faad2/libfaad/Makefile.am || die
	sed -i -e 's:../\(mp4v2/\):\1:g' ${PN}/mp4v2.patch || die
	sed -i -e 's:\(libmp4v2\|libfaad/libfaad\)\.la:README:g' \
		-e 's:^\(autoreconf\|pushd\|popd\):# \1:g' aacgain/linux/prepare.sh || die

	cd "${S}/${PN}/linux"
	sh prepare.sh || die "prepare failed!"

	cd "${S}"
	eautoreconf

	cd "${S}/faad2"
	eautoreconf

	cd "${S}/mp4v2"
	elibtoolize
}

src_configure() {
	local myconf="--disable-dependency-tracking"
	local myconf2="${myconf} --disable-shared --enable-static"

	cd "${S}/faad2"
	econf ${myconf2} --without-xmms --without-mpeg4ip

	cd "${S}/mp4v2"
	econf ${myconf2} --disable-gch

	cd "${S}"
	econf ${myconf}
}

src_compile() {
	cd "${S}/faad2/libfaad"
	emake

	cd "${S}/mp4v2"
	emake

	cd "${S}"
	emake
}

pkg_postinst() {
	ewarn
	ewarn "BACK UP YOUR MUSIC FILES BEFORE USING AACGAIN!"
	ewarn "THIS IS EXPERIMENTAL SOFTWARE. THERE HAVE BEEN"
	ewarn "BUGS IN PAST RELEASES THAT CORRUPTED MUSIC FILES."
	ewarn
}
