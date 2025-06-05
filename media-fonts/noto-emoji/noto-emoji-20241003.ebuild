# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit font

DESCRIPTION="Google Noto Emoji fonts"
HOMEPAGE="https://fonts.google.com/noto/specimen/Noto+Color+Emoji https://fonts.google.com/noto/specimen/Noto+Emoji
	https://github.com/googlefonts/noto-emoji https://github.com/zjaco13/Noto-Emoji-Monochrome"

# https://github.com/googlefonts/noto-emoji/issues/441
# https://github.com/googlefonts/noto-emoji/issues/390
COMMIT="22e564626297b4df0a40570ad81d6c05cc7c38bd"
COMMIT_MC="24d8485dc7eeda9ec8d08788dfacad75127aebc7"
SRC_URI="https://github.com/googlefonts/noto-emoji/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/zjaco13/Noto-Emoji-Monochrome/archive/${COMMIT_MC}.tar.gz -> ${P}-monochrome.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86"
IUSE="icons"

RESTRICT="binchecks strip"

# https://github.com/gentoo/gentoo/pull/32203
FONT_CONF=( "${FILESDIR}"/75-noto-emoji-fallback.conf )

src_compile() { :; }

src_install() {
	# Ensure we install only the desired font (the same other distros
	# supply), https://bugs.gentoo.org/927294
	FONT_S="${S}/fonts-install"

	# Don't lose fancy emoji icons
	if use icons; then
		for i in 32 72 128 512; do
			insinto "/usr/share/icons/${PN}/${i}/emotes/"
			doins png/"${i}"/*.png
		done

		insinto /usr/share/icons/"${PN}"/scalable/emotes/
		doins svg/*.svg
	fi

	# Ensure we install only the desired font (the same other distros
	# supply), https://bugs.gentoo.org/927294
	mkdir fonts-install || die
	FONT_S="${S}/fonts-install"
	cp -p fonts/NotoColorEmoji.ttf fonts-install/. || die
	cp -p "${WORKDIR}"/Noto-Emoji-Monochrome-${COMMIT_MC}/fonts/*.ttf fonts-install/. || die

	FONT_SUFFIX="ttf"
	font_src_install

	dodoc README.md
}
