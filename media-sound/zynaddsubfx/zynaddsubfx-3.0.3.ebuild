# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils flag-o-matic multilib

DESCRIPTION="ZynAddSubFX is an opensource software synthesizer"
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"
SRC_URI="mirror://sourceforge/zynaddsubfx/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa +fltk jack lash"

RDEPEND=">=dev-libs/mxml-2.2.1
	sci-libs/fftw:3.0
	media-libs/liblo
	alsa? ( media-libs/alsa-lib )
	fltk? ( >=x11-libs/fltk-1.3:1 )
	jack? ( virtual/jack )
	lash? ( media-sound/lash )"
#	portaudio? ( media-libs/portaudio )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
# Upstream uses the following preferences: alsa > jack > portaudio
# At least one of them must be enabled
# We do not support portaudio, so if alsa is disabled force jack.
REQUIRED_USE="!alsa? ( jack )"

PATCHES=(
	"${FILESDIR}"/${PN}-${PV}-docs.patch
)

DOCS=( ChangeLog HISTORY.txt README.adoc )

src_configure() {
	append-cxxflags "-std=c++11"
	use lash || sed -i -e 's/lash-1.0/lash_disabled/' "${S}"/src/CMakeLists.txt
	mycmakeargs=(
		`use fltk && echo "-DGuiModule=fltk" || echo "-DGuiModule=off"`
		`use alsa && echo "-DOutputModule=alsa" || echo "-DOutputModule=jack"`
		`use alsa && echo "-DAlsaMidiOutput=TRUE" || echo "-DAlsaMidiOutput=FALSE"`
		`use jack && echo "-DJackOutput=TRUE" || echo "-DJackOutput=FALSE"`
		-DPluginLibDir=$(get_libdir)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	insinto /usr/share/${PN}
	doins -r "${S}"/instruments/*
}
