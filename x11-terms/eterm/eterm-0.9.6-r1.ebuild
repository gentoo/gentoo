# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A vt102 terminal emulator for X"
HOMEPAGE="http://www.eterm.org/"
SRC_URI="
	http://www.eterm.org/download/${P^}.tar.gz
	!minimal? ( http://www.eterm.org/download/Eterm-bg-${PV}.tar.gz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ppc-macos ~x86-macos"
IUSE="escreen minimal cpu_flags_x86_mmx cpu_flags_x86_sse2 unicode +utempter"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libICE
	x11-libs/libSM
	x11-proto/xextproto
	x11-proto/xproto
	x11-libs/libast
	media-libs/imlib2[X]
	media-fonts/font-misc-misc
	escreen? ( app-misc/screen )
"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README ReleaseNotes bg/README.backgrounds )
PATCHES=( "${FILESDIR}"/${P}-asm-gnu-stack.patch )

S=${WORKDIR}/${P^}

src_unpack() {
	unpack ${P^}.tar.gz
	cd "${S}" || die
	use minimal || unpack Eterm-bg-${PV}.tar.gz
}

src_configure() {
	export TIC="true"
	econf \
		--disable-static \
		$(use_enable escreen) \
		--with-imlib \
		--enable-trans \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable unicode multi-charset) \
		$(use_enable utempter utmp) \
		--with-delete=execute \
		--with-backspace=auto
}

src_install() {
	use escreen && DOCS+=( doc/README.Escreen )
	default
	# We don't install headers to link against this library
	rm -f "${ED%/}"/usr/*/libEterm.{so,la} || die
}
