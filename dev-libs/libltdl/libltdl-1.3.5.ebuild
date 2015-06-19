# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libltdl/libltdl-1.3.5.ebuild,v 1.1 2014/11/03 05:31:48 vapier Exp ${P}-r1.ebuild,v 1.8 2002/10/04 06:34:42 kloeri Exp $

# This ebuild provides libltdl.so.0.

EAPI="4"

inherit multilib-minimal

MY_P="libtool-${PV}"

DESCRIPTION="A shared library tool for developers"
HOMEPAGE="http://www.gnu.org/software/libtool/"
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
