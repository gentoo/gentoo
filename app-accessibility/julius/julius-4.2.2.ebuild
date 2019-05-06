# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Large Vocabulary Continuous Speech Recognition Engine"
HOMEPAGE="https://github.com/julius-speech/julius"
SRC_URI="mirror://sourceforge.jp/julius/56549/${P}.tar.gz"

LICENSE="julius"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+alsa l10n_ja oss portaudio pulseaudio sndfile"
REQUIRED_USE="^^ ( alsa oss portaudio pulseaudio )"

RDEPEND="
	dev-lang/perl
	dev-perl/Jcode
	sys-libs/readline:0
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}
	sys-devel/flex"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.2-install.patch
	"${FILESDIR}"/${PN}-4.2.2-ldflags.patch
)

pkg_setup() {
	tc-export CC CXX
}

src_configure() {
	local mymic i
	for i in alsa oss portaudio pulseaudio ; do
		use ${i} && mymic=${i}
	done

	econf \
		--with-mictype=${mymic} \
		$(use_with sndfile)
}

src_install() {
	default
	if ! use l10n_ja ; then
		rm -r "${ED}"/usr/share/man/ja || die
	fi
}

pkg_postinst() {
	eerror "IMPORTANT NOTICE"
	elog "/usr/bin/jcontrol has been renamed to /usr/bin/jucontrol"
	elog "to avoid file collision with dev-java/java-config."
	elog "If this creates a problem with applications, file a gentoo bug."
}
