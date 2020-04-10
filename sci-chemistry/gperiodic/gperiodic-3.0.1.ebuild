# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Periodic table application for Linux"
HOMEPAGE="https://sourceforge.net/projects/gperiodic/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="nls"
MY_AVAILABLE_LINGUAS=" be bg cs da de es fi fr gl id is it lt ms nl pl pt_BR pt ru sv tr uk"

RDEPEND="
	sys-libs/ncurses:0
	x11-libs/gtk+:2
	x11-libs/cairo[X]
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-nls.patch
	for lang in ${MY_AVAILABLE_LINGUAS}; do
		if ! has ${lang} ${LINGUAS-${lang}}; then
			einfo "Cleaning translation for ${lang}"
			rm po/${lang}.po || die
		fi
	done
}

src_compile() {
	local myopts
	use nls && myopts="enable_nls=1" || myopts="enable_nls=0"
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC=$(tc-getCC) ${myopts}
}

src_install() {
	local myopts
	use nls && myopts="enable_nls=1" || myopts="enable_nls=0"
	emake DESTDIR="${D}" ${myopts} install
	dodoc AUTHORS ChangeLog README
	newdoc po/README README.translation
}
