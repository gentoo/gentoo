# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/portaudio/portaudio-19_pre20140130.ebuild,v 1.11 2014/10/13 07:31:25 mgorny Exp $

EAPI=5
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
inherit autotools-multilib

MY_P=pa_stable_v${PV/pre}

DESCRIPTION="A free, cross-platform, open-source, audio I/O library"
HOMEPAGE="http://www.portaudio.com/"
SRC_URI="http://www.portaudio.com/archives/${MY_P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="alsa +cxx debug jack oss static-libs"

RDEPEND="alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	jack? ( >=media-sound/jack-audio-connection-kit-0.121.3-r1[${MULTILIB_USEDEP}] )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r8
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}
DOCS=( README.txt )
HTML_DOCS=( index.html )

src_configure() {
	local myeconfargs=(
		$(use_enable debug debug-output)
		$(use_enable cxx)
		$(use_with alsa)
		$(use_with jack)
		$(use_with oss)
	)

	autotools-multilib_src_configure
}

src_compile() {
	autotools-multilib_src_compile lib/libportaudio.la
	autotools-multilib_src_compile
}
