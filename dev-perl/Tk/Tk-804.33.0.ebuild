# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SREZIC
MODULE_VERSION=804.033
inherit multilib perl-module

DESCRIPTION="A Perl Module for Tk"

LICENSE+=" tcltk BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND="
	media-libs/freetype
	>=media-libs/libpng-1.4:0
	virtual/jpeg
	x11-libs/libX11
	x11-libs/libXft"
RDEPEND="${DEPEND}"

# No test running here, requires an X server, and fails lots anyway.
SRC_TEST="skip"
PATCHES=(
	"${FILESDIR}"/${P}-xorg.patch
	)

src_prepare() {
	MAKEOPTS+=" -j1" #333049
	myconf=( X11ROOT=${EPREFIX}/usr XFT=1 -I${EPREFIX}/usr/include/ -l${EPREFIX}/usr/$(get_libdir) )
	mydoc="ToDo VERSIONS"

	perl-module_src_prepare
	# fix detection logic for Prefix, bug #385621
	sed -i -e "s:/usr:${EPREFIX}/usr:g" myConfig || die
	# having this around breaks with perl-module and a case-IN-sensitive fs
	rm build_ptk || die

	# Remove all bundled libs, fixes #488194
	local BUNDLED="PNG/libpng \
					PNG/zlib \
					JPEG/jpeg"
	for dir in ${BUNDLED}; do
		rm -r "${S}/${dir}" || die "Can't remove bundle"
		# Makefile.PL can copy files to ${S}/${dir}, so recreate them back.
		mkdir -p "${S}/${dir}" || die "Can't restore bundled dir"
		sed -i "\#^${dir}#d" "${S}"/MANIFEST || die 'Can not remove bundled libs from MANIFEST'
	done
}
