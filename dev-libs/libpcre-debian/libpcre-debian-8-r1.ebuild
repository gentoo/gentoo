# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib multilib-minimal

DESCRIPTION="libpcre(posix).so.3 symlinks for compatibility with Debian"
HOMEPAGE="http://www.pcre.org/"
LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libpcre:${SLOT}[${MULTILIB_USEDEP}]"

S="${WORKDIR}"

multilib_src_install() {
	dosym $(multilib_is_native_abi || echo /usr)/$(get_libdir)/libpcre.so.1 \
		  /usr/$(get_libdir)/debiancompat/libpcre.so.3

	dosym /usr/$(get_libdir)/libpcreposix.so.0 \
		  /usr/$(get_libdir)/debiancompat/libpcreposix.so.3
}
