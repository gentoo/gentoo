# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools optfeature

MY_PV="${PV%_p*}"
MY_P="${PN}-${MY_PV}"
PATCH_LEVEL="${PV#*_p}"
DEBIAN_VER="git20130108.4ca41f4"
DESCRIPTION="Multi-purpose WAVE data processing and reporting utility"
HOMEPAGE="http://shnutils.freeshell.org/shntool/"
SRC_URI="http://shnutils.freeshell.org/shntool/dist/src/${MY_P}.tar.gz"
SRC_URI+=" mirror://debian/pool/main/s/shntool/${MY_P/-/_}+${DEBIAN_VER}-${PATCH_LEVEL}.debian.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.10-fix_24bits.patch
	"${FILESDIR}"/${PN}-3.0.10-fix_gcc15.patch
)

src_prepare() {
	# Debian patchset
	PATCHES+=(
		$(awk '{print $1}' "${WORKDIR}"/debian/patches/series | sed -e '/^#/d' -e "s:^:${WORKDIR}/debian/patches/:")
	)

	default

	# bug #527310
	eautoreconf
}

src_install() {
	default
	dodoc -r doc/.
}

pkg_postinst() {
	optfeature_header "Several packages to support many audio formats:"
	optfeature "Apple Lossless Audio Codec (.alac)" media-sound/alac_decoder
	optfeature "Free Lossless Audio Codec (.flac)" media-libs/flac
	optfeature "Monkey's Audio Compressor (.ape)" media-sound/mac
	optfeature "Shorten (.shn)" media-sound/shorten
	optfeature "Audio Interchange File Format (.aiff)" media-sound/sox
	optfeature "TTA Lossless Audio Codec (.tta)" media-sound/ttaenc
	optfeature "WavPack Hybrid Lossless Audio Compression (.wv)" media-sound/wavpack
}
