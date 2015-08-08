# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
inherit eutils autotools

MY_P=Eterm-${PV}

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/eterm/Eterm"
	inherit subversion
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://www.eterm.org/download/${MY_P}.tar.gz
		!minimal? ( http://www.eterm.org/download/Eterm-bg-${PV}.tar.gz )"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ppc-macos ~x86-macos"
fi

DESCRIPTION="A vt102 terminal emulator for X"
HOMEPAGE="http://www.eterm.org/"

LICENSE="BSD"
SLOT="0"
IUSE="escreen minimal cpu_flags_x86_mmx cpu_flags_x86_sse2 unicode +utempter"

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libICE
	x11-libs/libSM
	x11-proto/xextproto
	x11-proto/xproto
	>=x11-libs/libast-0.6.1
	media-libs/imlib2[X]
	media-fonts/font-misc-misc
	escreen? ( app-misc/screen )"
DEPEND="${RDEPEND}"

if [[ ${PV} == "9999" ]] ; then
	S=${WORKDIR}/${ECVS_MODULE}
else
	S=${WORKDIR}/${MY_P}
fi

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		subversion_src_unpack
		cd "${S}"
		eautoreconf
	else
		unpack ${MY_P}.tar.gz
		cd "${S}"
		use minimal || unpack Eterm-bg-${PV}.tar.gz
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-asm-gnu-stack.patch #440618
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
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README ReleaseNotes
	use escreen && dodoc doc/README.Escreen
	dodoc bg/README.backgrounds

	# We don't install headers to link against this library
	rm -f "${D}"/usr/*/libEterm.{so,la}
}
