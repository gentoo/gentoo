# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/julius/julius-4.2.2.ebuild,v 1.3 2013/06/27 18:20:42 ago Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Large Vocabulary Continuous Speech Recognition Engine"
HOMEPAGE="http://julius.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/julius/56549/${P}.tar.gz"

LICENSE="julius"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+alsa oss portaudio pulseaudio sndfile"
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

pkg_setup() {
	tc-export CC CXX
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-install.patch \
		"${FILESDIR}"/${P}-ldflags.patch
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
	if ! has ja ${LINGUAS} ; then
		rm -r "${ED}"/usr/share/man/ja || die
	fi
}

pkg_postinst() {
	eerror "IMPORTANT NOTICE"
	elog "/usr/bin/jcontrol has been renamed to /usr/bin/jucontrol"
	elog "to avoid file collision with dev-java/java-config."
	elog "If this creates a problem with applications, file a gentoo bug."
}
