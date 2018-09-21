# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# font eclass is needed since "media-fonts/encodings" does not match
# check for pattern media-fonts/font* in xorg-2 eclass
inherit font xorg-2

DESCRIPTION="X.Org font encodings"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="x11-apps/mkfontscale
	>=media-fonts/font-util-1.1.1-r1"

ECONF_SOURCE="${S}"

pkg_postinst() {
	xorg-2_pkg_postinst
	font_pkg_postinst
}

pkg_postrm() {
	xorg-2_pkg_postrm
	font_pkg_postrm
}
