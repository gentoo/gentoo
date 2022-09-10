# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic pax-utils toolchain-funcs

DESCRIPTION="Argument-driven multi-system emulator utilizing OpenGL and SDL"
HOMEPAGE="https://mednafen.github.io/"
SRC_URI="https://mednafen.github.io/releases/files/${P}.tar.xz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa cpu_flags_ppc_altivec flac jack"

RDEPEND="
	app-arch/zstd:=
	dev-libs/lzo:2
	dev-libs/trio
	media-libs/libsdl2[joystick,opengl,video]
	media-libs/tremor
	media-sound/musepack-tools
	sys-libs/zlib:=[minizip]
	virtual/libintl
	alsa? ( media-libs/alsa-lib )
	flac? ( media-libs/flac:= )
	jack? ( virtual/jack )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	default

	# don't let the build system mess with CFLAGS more than necessary,
	# most are questionable (see README.PORTING/configure.ac comments)
	# -fwrapv: kept for bug #539992
	sed -e '/CC_OPT.*CODEGEN_FLAGS/{/-fwrapv/!d}' \
		-e '/CC_OPT.*NOPICPIE_FLAGS/d' \
		-e '/CC_OPT.*NO_STACK_PROTECTOR_FLAGS/d' \
		-e '/CC_OPT.*OPTIMIZER_FLAGS/c\:' \
		-e '/CC_OPT.*-mtune.*SS_EXTRA_FLAGS/d' \
		-e '/LINK_FLAG.*NOPICPIE_LDFLAGS/d' \
		-i configure.ac || die
	eautoreconf
}

src_configure() {
	# disable unnecessary warnings not to confuse users (see src/types.h)
	append-cppflags -DMDFN_DISABLE_{NO_OPT,PICPIE}_ERRWARN

	local myeconfargs=(
		$(use_enable alsa)
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable jack)
		$(use_with flac libflac)
		--with-external-{libzstd,lzo,mpcdec,tremor,trio}
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	local DOCS=(
		ChangeLog
		Documentation/{cheats.txt,fname_format.txt,modules.def,settings.def}
	)
	local HTML_DOCS=( Documentation/*.{css,html,png} )

	default

	pax-mark m "${ED}"/usr/bin/mednafen
}
