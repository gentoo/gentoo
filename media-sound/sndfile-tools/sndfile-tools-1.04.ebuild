# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A small collection of programs that use libsndfile"
HOMEPAGE="http://www.mega-nerd.com/libsndfile/tools/"

if [[ ${PV} == *9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/erikd/sndfile-tools.git"
else
	SRC_URI="http://www.mega-nerd.com/libsndfile/files/${P}.tar.bz2"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="jack"

RDEPEND="
	media-libs/libsndfile:=
	media-libs/libsamplerate:=
	x11-libs/cairo:=
	sci-libs/fftw:3.0=
	jack? ( media-sound/jack-audio-connection-kit:= )"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	econf $(use_enable jack)
}
