# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_P="${P}-source"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
DESCRIPTION="Speech synthesizer for English and other languages"
HOMEPAGE="http://espeak.sourceforge.net/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="portaudio pulseaudio"

COMMON_DEPEND="portaudio? ( >=media-libs/portaudio-19_pre20071207 )
	pulseaudio? ( media-sound/pulseaudio )"

DEPEND="${COMMON_DEPEND}
	app-arch/unzip"

RDEPEND="${COMMON_DEPEND}
	media-sound/sox"

PATCHES=( "${FILESDIR}"/${P}-gcc-6-fix.patch )

S="${WORKDIR}/${MY_P}/src"

get_audio() {
	if use portaudio && use pulseaudio; then
		echo runtime
	elif use portaudio; then
		echo portaudio
	elif use pulseaudio; then
		echo pulseaudio
	else
		echo none
	fi
}

src_prepare() {
	default
	# gentoo uses portaudio 19.
	mv -f portaudio19.h portaudio.h
}

src_compile() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		AR="$(tc-getAR)" \
		AUDIO="$(get_audio)" \
		all

	einfo "Fixing byte order of phoneme data files"
	pushd ../platforms/big_endian > /dev/null
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}"
	./espeak-phoneme-data \
		../../espeak-data \
		. \
		../../espeak-data/phondata-manifest
	cp -f phondata phonindex phontab "../../espeak-data"
}

src_install() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		DESTDIR="${D}" \
		AUDIO="$(get_audio)" \
		install

	cd ..
	insinto /usr/share/espeak-data
	doins -r dictsource
	dodoc ChangeLog.txt ReadMe
	HTML_DOCS="docs/*" einstalldocs
}

pkg_preinst() {
	local voicedir="${ROOT}/usr/share/${PN}-data/voices/en"
	if [ -d "${voicedir}" ]; then
		rm -rf "${voicedir}"
	fi
}

pkg_postinst() {
	if ! use portaudio && ! use pulseaudio; then
		ewarn "Since portaudio and pulseaudio are not in your use flags,"
		ewarn "espeak will only be able to create wav files."
		ewarn "If this is not what you want, please reemerge ${CATEGORY}/${PN}"
		ewarn "with either portaudio or pulseaudio USE flag enabled."
	fi
}
