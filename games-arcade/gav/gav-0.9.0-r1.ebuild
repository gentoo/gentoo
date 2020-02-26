# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="GPL Arcade Volleyball"
HOMEPAGE="http://gav.sourceforge.net/"
# the themes are behind a lame php-counter script.
SRC_URI="
	mirror://sourceforge/gav/${P}.tar.gz
	mirror://gentoo/fabeach.tgz
	mirror://gentoo/florindo.tgz
	mirror://gentoo/inverted.tgz
	mirror://gentoo/naive.tgz
	mirror://gentoo/unnamed.tgz
	mirror://gentoo/yisus.tgz
	mirror://gentoo/yisus2.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-net
	media-libs/libsdl[joystick,video]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-gcc43.patch
)

src_prepare() {
	default

	local d
	for d in . automa menu net; do
		cp ${d}/Makefile.Linux ${d}/Makefile || die "cp ${d}/Makefile failed"
	done

	# Now, move the additional themes in the proper directory
	mv ../{fabeach,florindo,inverted,naive,unnamed,yisus,yisus2} themes || die

	# no reason to have executable bit set on themes
	find themes -type f -exec chmod a-x '{}' \; || die
}

src_configure() {
	tc-export CXX
}

src_compile() {
	# bug #41530 - doesn't like the hot parallel make action.
	emake -C automa
	emake -C menu
	emake -C net
	emake
}

src_install() {
	dodir /usr/bin
	emake ROOT="${D}" install

	insinto /usr/share/${PN}
	doins -r sounds

	einstalldocs
}
