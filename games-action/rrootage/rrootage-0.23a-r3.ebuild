# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN="rRootage"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Abstract shooter - defeat auto-created huge battleships"
HOMEPAGE="https://www.asahi-net.or.jp/~cs8k-cyu/windows/rr_e.html
	https://rrootage.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_PN}/src

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/libbulletml-0.0.3
	media-libs/libsdl[joystick,video]
	media-libs/sdl-mixer[vorbis]
	virtual/glu
	virtual/opengl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}"-gcc41.patch
)

src_prepare() {
	default

	sed \
		-e "s/-lglut/-lGL -lGLU -lm/" \
		-e "/^CC/d" \
		-e "/^CXX/d" \
		-e "/^LDFLAGS/s/=/+=/" \
		-e "/^CPPFLAGS/s/MORE_CFLAGS/MORE_CXXFLAGS/" \
		-e "/^CPPFLAGS/s/MORE_CFLAGS/MORE_CXXFLAGS/" \
		-e "s/ -mwindows//" \
		-e "s:-I./bulletml/:-I/usr/include/bulletml:" \
		makefile.lin > Makefile || die

	sed -i \
		-e "s:/usr/share/games:/usr/share:" \
		barragemanager.cc screen.c soundmanager.c || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		MORE_CFLAGS="-DLINUX ${CFLAGS}" \
		MORE_CXXFLAGS="-DLINUX ${CXXFLAGS}"
}

src_install() {
	newbin rr ${PN}
	dodir "/usr/share/${MY_PN}"
	cp -r ../rr_share/* "${D}/usr/share/${MY_PN}" || die
	dodoc ../readme*
}

pkg_postinst() {
	if ! has_version "media-libs/sdl-mixer[vorbis]" ; then
		elog "${PN} will not have sound since sdl-mixer"
		elog "is built with USE=-vorbis"
		elog "Please emerge sdl-mixer with USE=vorbis"
		elog "if you want sound support"
	fi
}
