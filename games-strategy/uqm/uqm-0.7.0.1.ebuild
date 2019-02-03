# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop toolchain-funcs

MY_PV=$(ver_rs 3 '-')
MY_P="${PN}-${MY_PV}"
BASE_PV=$(ver_cut 1-3)
BASE_P="${PN}-${BASE_PV}"

DESCRIPTION="The Ur-Quan Masters: Port of Star Control 2"
HOMEPAGE="http://sc2.sourceforge.net/"
SRC_URI="mirror://sourceforge/sc2/${MY_P}-source.tgz
	mirror://sourceforge/sc2/${BASE_P}-content.uqm
	music? ( mirror://sourceforge/sc2/${BASE_P}-3domusic.uqm )
	voice? ( mirror://sourceforge/sc2/${BASE_P}-voice.uqm )
	remix? ( mirror://sourceforge/sc2/${PN}-remix-disc1.uqm \
		mirror://sourceforge/sc2/${PN}-remix-disc2.uqm \
		mirror://sourceforge/sc2/${PN}-remix-disc3.uqm \
		mirror://sourceforge/sc2/${PN}-remix-disc4.uqm )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="music opengl remix voice"

RDEPEND="
	media-libs/libmikmod
	media-libs/libogg
	>=media-libs/libpng-1.4:0=
	media-libs/libsdl[X,sound,joystick,video]
	media-libs/libvorbis
	media-libs/sdl-image[png]
	sys-libs/zlib
	opengl? ( virtual/opengl )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${BASE_P}-tempdir.patch"
	"${FILESDIR}/${BASE_P}-warning.patch"
)

src_prepare() {
	default

	local myopengl=$(usex opengl 'opengl' 'pure')

	cat <<-EOF > config.state
	CHOICE_debug_VALUE='nodebug'
	CHOICE_graphics_VALUE='${myopengl}'
	CHOICE_sound_VALUE='mixsdl'
	CHOICE_accel_VALUE='plainc'
	INPUT_install_prefix_VALUE='/usr/share'
	INPUT_install_bindir_VALUE='\$prefix/bin'
	INPUT_install_libdir_VALUE='\$prefix/lib'
	INPUT_install_sharedir_VALUE='/usr/share/'
	EOF

	# Take out the read so we can be non-interactive.
	sed -i \
		-e '/read CHOICE/d' build/unix/menu_functions || die

	# respect CFLAGS
	sed -i \
		-e "s/-O3//" build/unix/build.config || die

	sed -i \
		-e "s:@INSTALL_LIBDIR@:/usr/$(get_libdir)/:g" \
		build/unix/uqm-wrapper.in || die

	# respect CC
	sed -i \
		-e "s/PROG_gcc_FILE=\"gcc\"/PROG_gcc_FILE=\"$(tc-getCC)\"/" \
		build/unix/config_proginfo_build || die
}

src_compile() {
	MAKE_VERBOSE=1 ./build.sh uqm || die
}

src_install() {
	# Using the included install scripts seems quite painful.
	# This manual install is totally fragile but maybe they'll
	# use a sane build system for the next release.
	newbin uqm-wrapper uqm
	exeinto /usr/"$(get_libdir)"/${PN}
	doexe uqm

	insinto /usr/share/${PN}/content/packages
	doins "${DISTDIR}"/${BASE_P}-content.uqm
	echo ${BASE_P} > "${ED}"/usr/share/${PN}/content/version || die

	insinto /usr/share/${PN}/content/addons
	if use music; then
		doins "${DISTDIR}"/${BASE_P}-3domusic.uqm
	fi

	if use voice; then
		doins "${DISTDIR}"/${BASE_P}-voice.uqm
	fi

	if use remix; then
		insinto /usr/share/${PN}/content/addons
		doins "${DISTDIR}"/${PN}-remix-disc{1,2,3,4}.uqm
	fi

	dodoc AUTHORS ChangeLog Contributing README WhatsNew doc/users/manual.txt
	docinto devel
	dodoc doc/devel/[!n]*
	docinto devel/netplay
	dodoc doc/devel/netplay/*
	make_desktop_entry uqm "The Ur-Quan Masters"
}
