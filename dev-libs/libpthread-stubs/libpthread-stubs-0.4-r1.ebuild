# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Pthread functions stubs for platforms missing them"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/lib/pthread-stubs"
SRC_URI="https://xcb.freedesktop.org/dist/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

# there is nothing to compile for this package, all its contents are produced by
# configure. the only make job that matters is make install
multilib_src_compile() { true; }
