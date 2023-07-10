# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop multiprocessing toolchain-funcs

DESCRIPTION="The Ur-Quan Masters: Port of Star Control 2"
HOMEPAGE="https://sc2.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/sc2/${P}-src.tgz
	mirror://sourceforge/sc2/${P}-content.uqm
	music? ( mirror://sourceforge/sc2/${P}-3domusic.uqm )
	voice? ( mirror://sourceforge/sc2/${P}-voice.uqm )
	remix? (
		mirror://sourceforge/sc2/${PN}-remix-disc1.uqm
		mirror://sourceforge/sc2/${PN}-remix-disc2.uqm
		mirror://sourceforge/sc2/${PN}-remix-disc3.uqm
		mirror://sourceforge/sc2/${PN}-remix-disc4-1.uqm
	)"

LICENSE="CC-BY-2.0 CC-BY-NC-SA-2.5 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="music remix voice"

RDEPEND="
	media-libs/libmikmod
	media-libs/libpng:=
	media-libs/libsdl2[joystick,sound,video]
	media-libs/libvorbis
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	cat > config.state <<-EOF || die
		CHOICE_accel_VALUE='plainc'
		CHOICE_debug_VALUE='nodebug'
		CHOICE_mikmod_VALUE='external'
		INPUT_install_prefix_VALUE='${EPREFIX}/usr'
	EOF
	#CHOICE_sound_VALUE='$(usex openal{,} mixsdl)' # experimental and segfaults

	sed -i "/^PROG_gcc_FILE/s|=.*|='$(tc-getCC)'|" \
		build/unix/config_proginfo_build || die
	sed -i 's/-O3//' build/unix/build.config || die

	# use ${T} not to leave build files behind (bug 576098)
	sed -i "/^TEMPFILE=/s|=.*|='${T}/uqm'|" build/unix/config_functions || die
}

src_compile() {
	echo | MAKE_VERBOSE=1 ./build.sh -j$(makeopts_jobs) uqm || die
}

src_install() {
	dobin uqm
	doman doc/users/uqm.6

	insinto /usr/share/${PN}/content
	doins content/version

	insinto /usr/share/${PN}/content/packages
	doins "${DISTDIR}"/${P}-content.uqm

	insinto /usr/share/${PN}/content/addons
	use music && doins "${DISTDIR}"/${P}-3domusic.uqm
	use voice && doins "${DISTDIR}"/${P}-voice.uqm
	use remix && doins "${DISTDIR}"/${PN}-remix-disc{1,2,3,4-1}.uqm

	dodoc AUTHORS BUGS ChangeLog README WhatsNew doc/users/manual.txt

	doicon src/symbian/uqm.svg
	make_desktop_entry uqm "The Ur-Quan Masters"
}
