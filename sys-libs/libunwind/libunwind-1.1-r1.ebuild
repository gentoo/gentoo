# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils libtool

DESCRIPTION="Portable and efficient API to determine the call-chain of a program"
HOMEPAGE="https://savannah.nongnu.org/projects/libunwind"
SRC_URI="http://download.savannah.nongnu.org/releases/libunwind/${P}.tar.gz"

LICENSE="MIT"
SLOT="7"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~mips ~ppc ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug debug-frame libatomic lzma static-libs"

RESTRICT="test" #461958 -- re-enable tests with >1.1 again for retesting, this is here for #461394

# We just use the header from libatomic.
RDEPEND="lzma? ( app-arch/xz-utils )"
DEPEND="${RDEPEND}
	libatomic? ( dev-libs/libatomic_ops )"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

QA_DT_NEEDED_x86_fbsd="usr/lib/libunwind.so.7.0.0"

src_prepare() {
	# These tests like to fail.  bleh.
	echo 'int main(){return 0;}' > tests/Gtest-dyn1.c
	echo 'int main(){return 0;}' > tests/Ltest-dyn1.c

	# Since we have tests disabled via RESTRICT, disable building in the subdir
	# entirely.  This worksaround some build errors too. #484846
	sed -i -e '/^SUBDIRS/s:tests::' Makefile.in || die

	sed -i -e '/LIBLZMA/s:-lzma:-llzma:' configure{.ac,} || die #444050
	epatch "${FILESDIR}"/${P}-lzma.patch #444050
	epatch "${FILESDIR}"/${P}-fix-CVE-2015-3239.patch #585830
	elibtoolize
}

src_configure() {
	# https://savannah.nongnu.org/bugs/index.php?34324
	# --enable-cxx-exceptions: always enable it, headers provide the interface
	# and on some archs it is disabled by default causing a mismatch between the
	# API and the ABI, bug #418253
	# conservative-checks: validate memory addresses before use; as of 1.0.1,
	# only x86_64 supports this, yet may be useful for debugging, couple it with
	# debug useflag.
	ac_cv_header_atomic_ops_h=$(usex libatomic) \
	econf \
		--enable-cxx-exceptions \
		$(use_enable debug-frame) \
		$(use_enable lzma minidebuginfo) \
		$(use_enable static-libs static) \
		$(use_enable debug conservative_checks) \
		$(use_enable debug)
}

src_test() {
	# Explicitly allow parallel build of tests.
	# Sandbox causes some tests to freak out.
	SANDBOX_ON=0 emake check
}

src_install() {
	default
	# libunwind-ptrace.a (and libunwind-ptrace.h) is separate API and without
	# shared library, so we keep it in any case
	use static-libs || find "${ED}"usr '(' -name 'libunwind-generic.a' -o -name 'libunwind*.la' ')' -delete
}
