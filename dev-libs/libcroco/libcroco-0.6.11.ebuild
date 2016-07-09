# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib-minimal

DESCRIPTION="Generic Cascading Style Sheet (CSS) parsing and manipulation toolkit"
HOMEPAGE="https://git.gnome.org/browse/libcroco/"

LICENSE="LGPL-2"
SLOT="0.6"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

src_prepare() {
	if ! use test; then
		# don't waste time building tests
		sed 's/^\(SUBDIRS .*\=.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static \
		$([[ ${CHOST} == *-darwin* ]] && echo --disable-Bsymbolic)

	if multilib_is_native_abi; then
		ln -s "${S}"/docs/reference/html docs/reference/html || die
	fi
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README TODO"
	einstalldocs
}
