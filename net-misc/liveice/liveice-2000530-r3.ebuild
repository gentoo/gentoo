# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Live Source Client For IceCast"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	media-sound/lame
	media-sound/mpg123
	sys-libs/ncurses:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	tc-export CC
	append-flags -fcommon

	# seems to expect GNU's basename, but use simple builtin my_basename
	# rather than assume by forcing either -D_GNU_SOURCE or <libgen.h>
	econf ac_cv_func_basename=no #870838
}

src_install() {
	dobin liveice
	dodoc liveice.cfg README.{liveice,quickstart} README_new_mixer.txt Changes.txt
}
