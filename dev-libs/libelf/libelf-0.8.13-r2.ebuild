# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils multilib autotools multilib-minimal

DESCRIPTION="A ELF object file access library"
HOMEPAGE="http://www.mr511.de/software/"
SRC_URI="http://www.mr511.de/software/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ~mips ppc ppc64 sparc x86 ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug nls elibc_FreeBSD"

RDEPEND="!dev-libs/elfutils"
DEPEND="nls? ( sys-devel/gettext )"

DOCS=( ChangeLog README )
MULTILIB_WRAPPED_HEADERS=( /usr/include/libelf/sys_elf.h )

src_prepare() {
	eapply "${FILESDIR}/${P}-build.patch"
	eapply_user
	eautoreconf
}

multilib_src_configure() {
	# prefix might want to play with this; unfortunately the stupid
	# macro used to detect whether we're building ELF is so screwed up
	# that trying to fix it is just a waste of time.
	export mr_cv_target_elf=yes

	ECONF_SOURCE="${S}" econf \
		$(use_enable nls) \
		--enable-shared \
		$(use_enable debug)
}

multilib_src_install() {
	emake \
		prefix="${ED}usr" \
		libdir="${ED}usr/$(get_libdir)" \
		install \
		install-compat \
		-j1

	# Stop libelf from stamping on the system nlist.h
	use elibc_FreeBSD && rm "${ED}"/usr/include/nlist.h
}
