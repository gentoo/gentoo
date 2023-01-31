# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs multilib pax-utils

DESCRIPTION="An open-source memory debugger for GNU/Linux"
HOMEPAGE="https://valgrind.org"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://sourceware.org/git/${PN}.git"
	inherit git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/valgrind.gpg
	inherit verify-sig
	SRC_URI="https://sourceware.org/pub/valgrind/${P}.tar.bz2"
	SRC_URI+=" verify-sig? ( https://sourceware.org/pub/valgrind/${P}.tar.bz2.asc )"
	KEYWORDS="-* amd64 arm arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="mpi"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"
if [[ ${PV} != 9999 ]] ; then
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-valgrind )"
fi

PATCHES=(
	# Respect CFLAGS, LDFLAGS
	"${FILESDIR}"/${PN}-3.7.0-respect-flags.patch
	"${FILESDIR}"/${PN}-3.15.0-Build-ldst_multiple-test-with-fno-pie.patch
	"${FILESDIR}"/${P}-tests-clang16.patch
	"${FILESDIR}"/${P}-gcc-13.patch
)

src_prepare() {
	# Correct hard coded doc location
	sed -i -e "s:doc/valgrind:doc/${PF}:" docs/Makefile.am || die

	# Don't force multiarch stuff on OSX, bug #306467
	sed -i -e 's:-arch \(i386\|x86_64\)::g' Makefile.all.am || die

	if use elibc_musl ; then
		PATCHES+=(
			"${FILESDIR}"/${PN}-3.13.0-malloc.patch
			"${FILESDIR}"/${PN}-3.20.0-musl-interpose.patch
		)
	fi

	if [[ ${CHOST} == *-solaris* ]] ; then
		# upstream doesn't support this, but we don't build with
		# Sun/Oracle ld, we have a GNU toolchain, so get some things
		# working the Linux/GNU way
		find "${S}" -name "Makefile.am" -o -name "Makefile.tool.am" | xargs \
			sed -i -e 's:-M,/usr/lib/ld/map.noexstk:-z,noexecstack:' || die
		cp "${S}"/coregrind/link_tool_exe_{linux,solaris}.in
	fi

	default

	# Regenerate autotools files
	eautoreconf
}

src_configure() {
	local myconf=()

	# Respect ar, bug #468114
	tc-export AR

	# -fomit-frame-pointer	"Assembler messages: Error: junk `8' after expression"
	#                       while compiling insn_sse.c in none/tests/x86
	# -fstack-protector     more undefined references to __guard and __stack_smash_handler
	#                       because valgrind doesn't link to glibc (bug #114347)
	# -fstack-protector-all    Fails same way as -fstack-protector/-fstack-protector-strong.
	#                          Note: -fstack-protector-explicit is a no-op for Valgrind, no need to strip it
	# -fstack-protector-strong See -fstack-protector (bug #620402)
	# -m64 -mx32			for multilib-portage, bug #398825
	# -ggdb3                segmentation fault on startup
	# -flto*                fails to build, bug #858509
	filter-flags -fomit-frame-pointer
	filter-flags -fstack-protector
	filter-flags -fstack-protector-all
	filter-flags -fstack-protector-strong
	filter-flags -m64 -mx32
	filter-flags -fsanitize -fsanitize=*
	replace-flags -ggdb3 -ggdb2
	filter-lto

	if use amd64 || use ppc64; then
		! has_multilib_profile && myconf+=("--enable-only64bit")
	fi

	# Force bitness on darwin, bug #306467
	use x64-macos && myconf+=("--enable-only64bit")

	# Don't use mpicc unless the user asked for it (bug #258832)
	if ! use mpi; then
		myconf+=("--without-mpicc")
	fi

	econf "${myconf[@]}"
}

src_install() {
	default

	if [[ ${PV} == "9999" ]]; then
		# Otherwise FAQ.txt won't exist:
		emake -C docs FAQ.txt
		mv docs/FAQ.txt . || die "Couldn't move FAQ.txt"
	fi

	dodoc FAQ.txt

	pax-mark m "${ED}"/usr/$(get_libdir)/valgrind/*-*-linux

	# See README_PACKAGERS
	dostrip -x /usr/libexec/valgrind/vgpreload* /usr/$(get_libdir)/valgrind/*

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
	elog "Valgrind will not work if libc (e.g. glibc) does not have debug symbols."
	elog "To fix this you can add splitdebug to FEATURES in make.conf"
	elog "and remerge glibc. See:"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=214065"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=274771"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=388703"
}
