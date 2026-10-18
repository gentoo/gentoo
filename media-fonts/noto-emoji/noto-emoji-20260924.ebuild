# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font xdg-utils

DESCRIPTION="Google Noto Emoji fonts"
HOMEPAGE="https://fonts.google.com/noto/specimen/Noto+Color+Emoji https://fonts.google.com/noto/specimen/Noto+Emoji
	https://github.com/googlefonts/noto-emoji https://github.com/zjaco13/Noto-Emoji-Monochrome"

# https://github.com/googlefonts/noto-emoji/issues/441
# https://github.com/googlefonts/noto-emoji/issues/390
COMMIT="e20cbc2bbec1926686be9f9bee7d1d2cfa1fea0e"
COMMIT_MC="b80db438fe644bd25e0032661ab66fa72f2af0e2"
SRC_URI="https://github.com/googlefonts/noto-emoji/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/zjaco13/Noto-Emoji-Monochrome/archive/${COMMIT_MC}.tar.gz -> ${P}-monochrome.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="icons"

RESTRICT="binchecks strip"

# https://github.com/gentoo/gentoo/pull/32203
FONT_CONF=( "${FILESDIR}"/75-noto-emoji-fallback.conf )

src_compile() { :; }

src_install() {
	# Don't lose fancy emoji icons
	if use icons; then
		for i in 32 72 128 512; do
			insinto "/usr/share/icons/${PN}-2D/${i}/emotes/"
			doins 2D/png/"${i}"/*.png
			insinto "/usr/share/icons/${PN}-3D/${i}/emotes/"
			doins 3D/png/"${i}"/*.png
		done

		insinto /usr/share/icons/"${PN}-2D"/scalable/emotes/
		doins 2D/svg/*.svg
	fi

	# Ensure we install only the desired font (the same other distros
	# supply), https://bugs.gentoo.org/927294
	mkdir fonts-install || die
	FONT_S="${S}/fonts-install"
	cp -p 2D/fonts/NotoColorEmoji.ttf fonts-install/. || die
	cp -p 3D/fonts/Noto-3D-192.ttf fonts-install/. || die
	cp -p "${WORKDIR}"/Noto-Emoji-Monochrome-${COMMIT_MC}/fonts/*.ttf fonts-install/. || die

	FONT_SUFFIX="ttf"
	font_src_install

	dodoc README.md
}

pkg_postinst() {
	use icons && xdg_icon_cache_update
}

pkg_postrm() {
	use icons && xdg_icon_cache_update
}
