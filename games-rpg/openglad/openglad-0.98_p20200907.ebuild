# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

MY_COMMIT="80e33b15cfa6d7d288b4b3db4dcca0349f13691f"

DESCRIPTION="SDL clone of Gladiator, a classic RPG game"
HOMEPAGE="https://snowstorm.sourceforge.net/"
SRC_URI="
	https://github.com/openglad/openglad/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz
	mirror://gentoo/${PN}.png"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="Boost-1.0 GPL-2+ ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libyaml
	dev-libs/libzip:=
	media-libs/libpng:=
	media-libs/libsdl2[joystick,opengl,sound,video]
	media-libs/sdl2-mixer"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/premake:5
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default

	# game uses the binary's location for assets even with a wrapper
	sed -e '/^std::string get_asset_path/!b;n' \
		-e "a\\return \"${EPREFIX}/usr/share/${PN}/\";" \
		-i src/io.cpp || die

	# unbundle (delete + add to pkg-config below is enough)
	# physfs: need missing physfsrwops.h matching system's to unbundle
	rm -r src/external/{libyaml,libzip} || die

	# cleanup not to install
	rm sound/Makefile.am || die
}

src_configure() {
	# premake4.lua assumes a lot (e.g. no SDL2 include path), check ourselves
	local pkgs=( SDL2_mixer libpng libzip sdl2 yaml-0.1 )
	append-cppflags $($(tc-getPKG_CONFIG) --cflags "${pkgs[@]}" || die)
	append-libs $($(tc-getPKG_CONFIG) --libs "${pkgs[@]}" || die)

	premake5 gmake || die
}

src_compile() {
	local emakeargs=(
		config=release
		verbose=y
		ARCH= # build assumes this is -m64 and tries to pass it to the compiler
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		LIBS="${LIBS}"
		ALL_LDFLAGS="${LDFLAGS}" # only used to override -s
	)

	emake "${emakeargs[@]}"
}

src_install() {
	dobin bin/Release/${PN}

	insinto /usr/share/${PN}
	doins -r builtin cfg extra_campaigns pix sound
	# note: extra_campaigns not directly used, but users may want them

	dodoc {cheats,classes,scen}.txt
	einstalldocs

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
