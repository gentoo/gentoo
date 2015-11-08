# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit autotools-multilib flag-o-matic gnome2-utils pax-utils

DESCRIPTION="The Oil Runtime Compiler, a just-in-time compiler for array operations"
HOMEPAGE="http://gstreamer.freedesktop.org/"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ~ppc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples pax_kernel static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/gtk-doc-am-1.12
"

src_prepare() {
	if ! use examples; then
		sed -e '/SUBDIRS/ s:examples::' \
			-i Makefile.am Makefile.in || die
	fi

	gnome2_environment_reset #556160
}

src_configure() {
	# any optimisation on PPC/Darwin yields in a complaint from the assembler
	# Parameter error: r0 not allowed for parameter %lu (code as 0 not r0)
	# the same for Intel/Darwin, although the error message there is different
	# but along the same lines
	[[ ${CHOST} == *-darwin* ]] && filter-flags -O*
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install
	if use pax_kernel; then
		pax-mark m "${ED}"usr/bin/orc-bugreport
		pax-mark m "${ED}"usr/bin/orcc
		pax-mark m "${ED}"usr/$(get_libdir)/liborc*.so*
	fi
}

pkg_postinst() {
	if use pax_kernel; then
		ewarn "Please run \"revdep-pax\" after installation".
		ewarn "It's provided by sys-apps/elfix."
	fi
}
