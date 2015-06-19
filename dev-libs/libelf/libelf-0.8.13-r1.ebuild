# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libelf/libelf-0.8.13-r1.ebuild,v 1.13 2012/11/29 13:42:25 blueness Exp $

EAPI="3"

inherit eutils multilib autotools

DESCRIPTION="A ELF object file access library"
HOMEPAGE="http://www.mr511.de/software/"
SRC_URI="http://www.mr511.de/software/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug nls elibc_FreeBSD"

RDEPEND="!dev-libs/elfutils"
DEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}/${P}-build.patch"
	eautoreconf

}

src_configure() {
	# prefix might want to play with this; unfortunately the stupid
	# macro used to detect whether we're building ELF is so screwed up
	# that trying to fix it is just a waste of time.
	export mr_cv_target_elf=yes

	econf \
		$(use_enable nls) \
		--enable-shared \
		$(use_enable debug)
}

src_install() {
	emake \
		prefix="${ED}usr" \
		libdir="${ED}usr/$(get_libdir)" \
		install \
		install-compat \
		-j1 || die

	dodoc ChangeLog README || die

	# Stop libelf from stamping on the system nlist.h
	use elibc_FreeBSD && rm "${ED}"/usr/include/nlist.h
}
