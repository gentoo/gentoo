# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit font

DESCRIPTION="Google's font family that aims to support all the world's languages"
HOMEPAGE="https://fonts.google.com/noto https://github.com/notofonts/notofonts.github.io"

COMMIT="6934f8608dc8235a028a7b4b3d10888df74faf83"
SRC_URI="https://github.com/notofonts/notofonts.github.io/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~mips ~ppc ppc64 ~riscv ~sparc x86"
# Extra allows to optionally reduce disk usage even returning to tofu
# issue as described in https://fonts.google.com/noto
IUSE="cjk +extra"

RDEPEND="cjk? ( media-fonts/noto-cjk )"

RESTRICT="binchecks strip"

S="${WORKDIR}/notofonts.github.io-${COMMIT}"

FONT_SUFFIX="ttf"
FONT_CONF=(
	# From ArchLinux
	"${FILESDIR}/66-noto-serif.conf"
	"${FILESDIR}/66-noto-mono.conf"
	"${FILESDIR}/66-noto-sans.conf"
)

src_install() {
	mkdir install-hinted || die
	mv fonts/*/hinted/ttf/*.tt[fc] install-hinted/. || die

	FONT_S="${S}/install-hinted/" font_src_install

	# Allow to drop some fonts optionally for people that want to save
	# disk space. Following ArchLinux options.
	use extra || rm -rf "${ED}"/usr/share/fonts/noto/Noto*{Condensed,SemiBold,Extra}*.tt[f,c]
}
