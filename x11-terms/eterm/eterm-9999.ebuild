# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools git-r3

DESCRIPTION="A vt102 terminal emulator for X"
HOMEPAGE="http://www.eterm.org/"
EGIT_REPO_URI="https://git.enlightenment.org/apps/eterm.git"

LICENSE="BSD"
SLOT="0"
IUSE="escreen minimal cpu_flags_x86_mmx cpu_flags_x86_sse2 unicode +utempter"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libast
	media-libs/imlib2[X]
	media-fonts/font-misc-misc
	escreen? ( app-misc/screen )
"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README ReleaseNotes bg/README.backgrounds )

src_prepare() {
	default
	eautoreconf
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
