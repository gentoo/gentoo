# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit eutils flag-o-matic toolchain-funcs python-any-r1

DESCRIPTION="GNU utilities for finding files"
HOMEPAGE="https://www.gnu.org/software/findutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls selinux static test"

RDEPEND="selinux? ( sys-libs/libselinux )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )
	nls? ( sys-devel/gettext )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# Don't build or install locate because it conflicts with slocate,
	# which is a secure version of locate.  See bug 18729
	sed -i '/^SUBDIRS/s/locate//' Makefile.in

	# Newer C libraries omit this include from sys/types.h.
	# https://lists.gnu.org/archive/html/bug-gnulib/2016-03/msg00018.html
	sed -i \
		'/include.*config.h/a#ifdef MAJOR_IN_SYSMACROS\n#include <sys/sysmacros.h>\n#endif\n' \
		gl/lib/mountlist.c || die

	epatch "${FILESDIR}"/${P}-gnulib-mb.patch #576818
	epatch "${FILESDIR}"/${P}-gnulib-S_MAGIC_NFS.patch #580032
}

src_configure() {
	use static && append-ldflags -static

	program_prefix=$(usex userland_GNU '' g)
	econf \
		--with-packager="Gentoo" \
		--with-packager-version="${PVR}" \
		--with-packager-bug-reports="https://bugs.gentoo.org/" \
		--program-prefix=${program_prefix} \
		$(use_enable nls) \
		$(use_with selinux) \
		--libexecdir='$(libdir)'/find
}

src_compile() {
	# We don't build locate, but the docs want a file in there.
	emake -C locate dblocation.texi
	default
}
