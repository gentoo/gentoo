# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
inherit autotools-multilib

DESCRIPTION="A free, cross-platform, open-source, audio I/O library"
HOMEPAGE="http://www.portaudio.com/"
SRC_URI="http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="alsa +cxx debug jack oss static-libs"

RDEPEND="alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )"
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
