# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}
inherit autotools eutils libtool multilib-minimal

DESCRIPTION="Portable and efficient API to determine the call-chain of a program"
HOMEPAGE="https://savannah.nongnu.org/projects/libunwind"
SRC_URI="mirror://nongnu/libunwind/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="7"
KEYWORDS="amd64 arm arm64 hppa ia64 ~mips ppc ppc64 -sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug debug-frame doc libatomic lzma +static-libs"

RESTRICT="test" # half of tests are broken (toolchain version dependent)

# We just use the header from libatomic.
RDEPEND="lzma? ( app-arch/xz-utils )"
DEPEND="${RDEPEND}
	libatomic? ( dev-libs/libatomic_ops )"

S="${WORKDIR}/${MY_P}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libunwind.h

	# see libunwind.h for the full list of arch-specific headers
	/usr/include/libunwind-aarch64.h
	/usr/include/libunwind-arm.h
	/usr/include/libunwind-hppa.h
	/usr/include/libunwind-ia64.h
	/usr/include/libunwind-mips.h
	/usr/include/libunwind-ppc32.h
	/usr/include/libunwind-ppc64.h
	/usr/include/libunwind-sh.h
	/usr/include/libunwind-tilegx.h
	/usr/include/libunwind-x86.h
	/usr/include/libunwind-x86_64.h
)

PATCHES=(
	"${FILESDIR}"/${PN}-1.2-coredump-regs.patch #586092
	"${FILESDIR}"/${PN}-1.2-ia64-undwarf.patch
	"${FILESDIR}"/${PN}-1.2-ia64-ptrace-coredump.patch
	"${FILESDIR}"/${PN}-1.2-ia64-missing.patch
	"${FILESDIR}"/${PN}-1.2.1-fix_version_macros.patch
	"${FILESDIR}"/${PN}-1.2.1-only-include-execinfo_h-if-avaliable.patch
	"${FILESDIR}"/${PN}-1.2.1-no-PROTECTED.patch #659732
)

src_prepare() {
	default
	chmod +x src/ia64/mk_cursor_i || die
	# Since we have tests disabled via RESTRICT, disable building in the subdir
	# entirely.  This worksaround some build errors too. #484846
	sed -i -e '/^SUBDIRS/s:tests::' Makefile.in || die

	elibtoolize
	eautoreconf
}

multilib_src_configure() {
	# --enable-cxx-exceptions: always enable it, headers provide the interface
	# and on some archs it is disabled by default causing a mismatch between the
	# API and the ABI, bug #418253
	# conservative-checks: validate memory addresses before use; as of 1.0.1,
	# only x86_64 supports this, yet may be useful for debugging, couple it with
	# debug useflag.
	ECONF_SOURCE="${S}" \
	ac_cv_header_atomic_ops_h=$(usex libatomic) \
	econf \
		--enable-cxx-exceptions \
		--enable-coredump \
		--enable-ptrace \
		--enable-setjmp \
		$(use_enable debug-frame) \
		$(use_enable doc documentation) \
		$(use_enable lzma minidebuginfo) \
		$(use_enable static-libs static) \
		$(use_enable debug conservative_checks) \
		$(use_enable debug)
}

multilib_src_compile() {
	# Bug 586208
	CCACHE_NODIRECT=1 default
}

multilib_src_test() {
	# Explicitly allow parallel build of tests.
	# Sandbox causes some tests to freak out.
	SANDBOX_ON=0 emake check
}

multilib_src_install() {
	default
	# libunwind-ptrace.a (and libunwind-ptrace.h) is separate API and without
	# shared library, so we keep it in any case
	use static-libs || find "${ED}"usr '(' -name 'libunwind-generic.a' -o -name 'libunwind*.la' ')' -delete
}
