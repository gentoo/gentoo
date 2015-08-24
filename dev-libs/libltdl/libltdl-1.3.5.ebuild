# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# This ebuild provides libltdl.so.0.

EAPI="4"

inherit multilib-minimal

MY_P="libtool-${PV}"

DESCRIPTION="A shared library tool for developers"
HOMEPAGE="https://www.gnu.org/software/libtool/"
SRC_URI="mirror://gnu/libtool/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="1.3"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""
# libltdl doesn't have a testsuite.
RESTRICT="test"

RDEPEND="!sys-devel/libtool:1.3"

S="${WORKDIR}/${MY_P}"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--enable-ltdl-install \
		--disable-static
}

multilib_src_compile() {
	emake -C libltdl
}

multilib_src_install() {
	emake -C libltdl DESTDIR="${D}" install-exec
	# basically we just install ABI libs for old packages
	rm "${ED}"/usr/$(get_libdir)/libltdl.{la,so} || die
}
