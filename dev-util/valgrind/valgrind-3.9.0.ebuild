# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit autotools eutils flag-o-matic toolchain-funcs multilib pax-utils

DESCRIPTION="An open-source memory debugger for GNU/Linux"
HOMEPAGE="http://www.valgrind.org"
SRC_URI="http://www.valgrind.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="mpi"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

src_prepare() {
	# Correct hard coded doc location
	sed -i -e "s:doc/valgrind:doc/${PF}:" docs/Makefile.am || die

	# Don't force multiarch stuff on OSX, bug #306467
	sed -i -e 's:-arch \(i386\|x86_64\)::g' Makefile.all.am || die

	# Respect CFLAGS, LDFLAGS
	epatch "${FILESDIR}"/${PN}-3.7.0-respect-flags.patch

	# Changing Makefile.all.am to disable SSP
	epatch "${FILESDIR}"/${PN}-3.7.0-fno-stack-protector.patch

	# Yet more local labels, this time for ppc32 & ppc64
	epatch "${FILESDIR}"/${PN}-3.6.0-local-labels.patch

	# Don't build in empty assembly files for other platforms or we'll get a QA
	# warning about executable stacks.
	epatch "${FILESDIR}"/${PN}-3.9.0-non-exec-stack.patch

	# glibc 2.19 fix
	epatch "${FILESDIR}"/${PN}-3.9.0-glibc-2.19.patch

	# Regenerate autotools files
	eautoreconf
}

src_configure() {
	local myconf

	# Respect ar, bug #468114
	tc-export AR

	# -fomit-frame-pointer	"Assembler messages: Error: junk `8' after expression"
	#                       while compiling insn_sse.c in none/tests/x86
	# -fpie                 valgrind seemingly hangs when built with pie on
	#                       amd64 (bug #102157)
	# -fstack-protector     more undefined references to __guard and __stack_smash_handler
	#                       because valgrind doesn't link to glibc (bug #114347)
	# -m64 -mx32			for multilib-portage, bug #398825
	# -ggdb3                segmentation fault on startup
	filter-flags -fomit-frame-pointer
	filter-flags -fpie
	filter-flags -fstack-protector
	filter-flags -m64 -mx32
	replace-flags -ggdb3 -ggdb2

	if use amd64 || use ppc64; then
		! has_multilib_profile && myconf="${myconf} --enable-only64bit"
	fi

	# Force bitness on darwin, bug #306467
	use x86-macos && myconf="${myconf} --enable-only32bit"
	use x64-macos && myconf="${myconf} --enable-only64bit"

	# Don't use mpicc unless the user asked for it (bug #258832)
	if ! use mpi; then
		myconf="${myconf} --without-mpicc"
	fi

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS FAQ.txt NEWS README*

	pax-mark m "${ED}"/usr/$(get_libdir)/valgrind/*-*-linux

	if [[ ${CHOST} == *-darwin* ]] ; then
		# fix install_names on shared libraries, can't turn them into bundles,
		# as dyld won't load them any more then, bug #306467
		local l
		for l in "${ED}"/usr/lib/valgrind/*.so ; do
			install_name_tool -id "${EPREFIX}"/usr/lib/valgrind/${l##*/} "${l}"
		done
	fi
}

pkg_postinst() {
	elog "Valgrind will not work if glibc does not have debug symbols."
	elog "To fix this you can add splitdebug to FEATURES in make.conf"
	elog "and remerge glibc.  See:"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=214065"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=274771"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=388703"
}
