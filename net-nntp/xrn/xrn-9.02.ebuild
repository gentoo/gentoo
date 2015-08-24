# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A small and fast news reader for X"
HOMEPAGE="http://www.mit.edu/people/jik/software/xrn.html"
SRC_URI="ftp://sipb.mit.edu/pub/${PN}/${P}.tgz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="x86"
IUSE=""

RDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXp
	x11-libs/libXpm
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-misc/imake
	>=sys-apps/sed-4"

src_compile() {
	# English is the default language, but french and german are also
	# supported, however only one language may be supported at a time:
	local lingua
	for lingua in ${LINGUAS} en ; do
		case "${lingua}" in
			en*)
				MY_LANG="english"
				break # Breaks the for loop.
				;;
			fr*)
				MY_LANG="french"
				break # Breaks the for loop.
				;;
			de*)
				MY_LANG="german"
				break # Breaks the for loop.
				;;
		esac
	done

	# Bugs to Gentoo bugzilla:
	sed -i \
		-e "s,bug-xrn@kamens.brookline.ma.us,https://bugs.gentoo.org/," \
		-e "s,\(#ifndef CONFIG_H_IS_OK\),#define CONFIG_H_IS_OK\n\1," \
		config.h

	# Generate Makefile:
	xmkmf || die "xmkmf failed"

	# Use our own CFLAGS and our desired language:
	emake -j1 CDEBUGFLAGS="${CFLAGS}" LANGUAGE="${MY_LANG}" || die "emake failed"
}

src_install() {
	dobin xrn || die "dobin failed"
	dodoc README README.Linux TODO CREDITS COMMON-PROBLMS || die "dodoc failed"

	# Default settings:
	insinto /etc/X11/app-defaults
	newins XRn.ad XRn

	newman xrn.man xrn.1
}
