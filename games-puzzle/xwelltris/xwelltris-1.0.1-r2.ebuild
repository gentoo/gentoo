# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs prefix

DESCRIPTION="2.5D tetris like game"
HOMEPAGE="http://xnc.jinr.ru/xwelltris/"
SRC_URI="http://xnc.jinr.ru/xwelltris/src/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-image[gif]
"
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"

PATCHES=(
	# Look in ${EPREFIX}/var/lib/xwelltris for score file
	"${FILESDIR}"/${PN}-1.0.1-scorefile-dir.patch
	"${FILESDIR}"/${PN}-1.0.1-gcc-11.patch
	"${FILESDIR}"/${PN}-1.0.1-c++17.patch
	"${FILESDIR}"/${PN}-1.0.1-configure-autoconf-2.72.patch
)

src_prepare() {
	default

	sed -i \
		-e '/INSTALL_PROGRAM/s/-s //' \
		src/Make.common.in || die

	sed -i \
		-e "/GLOBAL_SEARCH/s:\".*\":\"/usr/share/${PN}\":" \
		src/include/globals.h.in || die

	# Ensure we look in ${EPREFIX}/var/lib/${PN} for score file
	eprefixify src/commonfuncs.cxx

	# Needed for autotools-2.72 patch + clang 16 (bug #899014)
	eautoreconf
}

src_configure() {
	tc-export CC CXX

	# configure/build process is pretty messed up
	econf --with-sdl
}

src_compile() {
	emake -C src
}

src_install() {
	dodir /usr/bin /usr/share/${PN} /var/lib/${PN} /usr/share/man

	emake install \
		INSTDIR="${D}/usr/bin" \
		INSTLIB="${D}/usr/share/${PN}" \
		INSTMAN=/usr/share/man

	dodoc AUTHORS Changelog README*

	# Move score file to our location
	mv "${ED}"/usr/share/${PN}/welltris.scores "${ED}"/var/lib/${PN}/welltris.scores || die

	fowners root:gamestat /var/lib/${PN}/welltris.scores /usr/bin/${PN}
	fperms 660 /var/lib/${PN}/welltris.scores
	fperms g+s /usr/bin/${PN}
}
