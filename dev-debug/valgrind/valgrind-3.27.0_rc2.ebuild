# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The Valgrind upstream maintainer also maintains it in Fedora and will
# backport fixes there which haven't yet made it into a release. Keep an eye
# on it for fixes we should cherry-pick too:
# https://src.fedoraproject.org/rpms/valgrind/tree/rawhide
#
# Also check the ${PV}_STABLE branch upstream for backports.

inherit autotools dot-a flag-o-matic toolchain-funcs multilib pax-utils

DESCRIPTION="An open-source memory debugger for GNU/Linux"
HOMEPAGE="https://valgrind.org"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="
		https://sourceware.org/git/${PN}.git
		https://git.sr.ht/~sourceware/valgrind
	"
	inherit git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/valgrind.asc
	inherit verify-sig

	MY_P="${P/_rc/.RC}"
	MY_P="${MY_P%%_p*}"
	VALGRIND_PATCH_TARBALL="${MY_P}-patches-${PV##*_p}"
	SRC_URI="
		https://sourceware.org/pub/valgrind/${MY_P}.tar.bz2
		verify-sig? ( https://sourceware.org/pub/valgrind/${MY_P}.tar.bz2.asc )
	"
	# Rollups of backports on ${PV}_STABLE branch upstream. This branch
	# is usually announced on the mailing list and distros are encouraged
	# to pull from it regularly.
	if [[ ${PV} == *_p* ]] ; then
		SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${VALGRIND_PATCH_TARBALL}.tar.xz"
	fi

	S="${WORKDIR}"/${MY_P}

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="-* ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~x64-macos ~x64-solaris"
	fi
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="mpi"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"
if [[ ${PV} == 9999 ]] ; then
	# Needed for man pages
	BDEPEND+="
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	"
else
	BDEPEND+=" verify-sig? ( >=sec-keys/openpgp-keys-valgrind-20251018 )"
fi

PATCHES=(
	# Respect CFLAGS, LDFLAGS
	"${FILESDIR}"/${PN}-3.7.0-respect-flags.patch
	"${FILESDIR}"/${PN}-3.15.0-Build-ldst_multiple-test-with-fno-pie.patch
	"${FILESDIR}"/${PN}-3.21.0-glibc-2.34-suppressions.patch
)

QA_CONFIG_IMPL_DECL_SKIP+=(
	# "checking if gcc accepts nested functions" but clang cannot handle good
	# errors and reports both "function definition is not allowed here" and
	# -Wimplicit-function-declaration. bug #900396
	foo
	# FreeBSD function, bug #932822
	aio_readv
)

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	elif use verify-sig ; then
		# Needed for downloaded patch (which is unsigned, which is fine)
		verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.bz2{,.asc}
	fi

	default
}

src_prepare() {
	# Correct hard coded doc location
	sed -i -e "s:doc/valgrind:doc/${PF}:" docs/Makefile.am || die

	# Don't force multiarch stuff on OSX, bug #306467
	sed -i -e 's:-arch \(i386\|x86_64\)::g' Makefile.all.am || die

	if [[ ${CHOST} == *-solaris* ]] ; then
		# upstream doesn't support this, but we don't build with
		# Sun/Oracle ld, we have a GNU toolchain, so get some things
		# working the Linux/GNU way
		find "${S}" -name "Makefile.am" -o -name "Makefile.tool.am" | xargs \
			sed -i -e 's:-M,/usr/lib/ld/map.noexstk:-z,noexecstack:' || die
		cp "${S}"/coregrind/link_tool_exe_{linux,solaris}.in
	fi

	if [[ ${PV} != 9999 && -d "${WORKDIR}"/${VALGRIND_PATCH_TARBALL} ]] ; then
		PATCHES+=( "${WORKDIR}"/${VALGRIND_PATCH_TARBALL} )
	fi

	default

	eautoreconf
}

src_configure() {
	local myconf=(
		--with-gdbscripts-dir="${EPREFIX}"/usr/share/gdb/auto-load
	)

	tc-is-lto && myconf+=( --enable-lto )
	lto-guarantee-fat

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
	# -fharden-control-flow-redundancy: breaks runtime ('jump to the invalid address stated on the next line')
	filter-flags -fomit-frame-pointer
	filter-flags -fstack-protector
	filter-flags -fstack-protector-all
	filter-flags -fstack-protector-strong
	filter-flags -m64 -mx32
	filter-flags -fsanitize -fsanitize=*
	filter-flags -fharden-control-flow-redundancy
	append-cflags $(test-flags-CC -fno-harden-control-flow-redundancy)
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

src_test() {
	# fxsave.o, tronical.o have textrels
	# -fno-strict-aliasing: https://bugs.kde.org/show_bug.cgi?id=486093
	emake CFLAGS="${CFLAGS} -fno-strict-aliasing" LDFLAGS="${LDFLAGS} -Wl,-z,notext" check
}

src_install() {
	if [[ ${PV} == 9999 ]]; then
		# TODO: Could do HTML docs too with 'all-docs'
		emake -C docs man-pages FAQ.txt
		mv docs/FAQ.txt . || die "Couldn't move FAQ.txt"
	fi

	default

	dodoc FAQ.txt

	pax-mark m "${ED}"/usr/$(get_libdir)/valgrind/*-*-linux

	strip-lto-bytecode

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
	elog "https://bugs.gentoo.org/214065"
	elog "https://bugs.gentoo.org/274771"
	elog "https://bugs.gentoo.org/388703"
}
