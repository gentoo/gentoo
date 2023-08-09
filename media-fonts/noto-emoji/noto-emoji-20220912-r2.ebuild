# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit font

DESCRIPTION="Google Noto Emoji fonts"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlefonts/noto-emoji"

COMMIT="e8073ab740292f8d5f19b5de144087ac58044d06"
SRC_URI="https://github.com/googlefonts/noto-emoji/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="icons"

RESTRICT="binchecks strip"

S="${WORKDIR}/${PN}-${COMMIT}"

# https://github.com/gentoo/gentoo/pull/32203
FONT_CONF=( "${FILESDIR}"/75-noto-emoji-fallback.conf )

src_prepare() {
	default

	# Drop font for Windows 10
	rm fonts/NotoColorEmoji_WindowsCompatible.ttf || die
}

src_compile() { :; }

src_install() {
	FONT_S="${S}/fonts"
	# Drop non used fonts
	rm -f fonts/*COLR*.ttf || die

	# Don't lose fancy emoji icons
	if use icons; then
		for i in 32 72 128 512; do
			insinto "/usr/share/icons/${PN}/${i}/emotes/"
			doins png/"${i}"/*.png
		done

		insinto /usr/share/icons/"${PN}"/scalable/emotes/
		doins svg/*.svg
	fi

	FONT_SUFFIX="ttf"
	font_src_install

	dodoc README.md
}
