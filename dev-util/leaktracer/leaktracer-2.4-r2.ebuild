# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib toolchain-funcs

# Upstream-package has no version in it's name.
# We therefore repackage it directly, together with the patches.
PATCH_LEVEL="2"

DESCRIPTION="trace and analyze memory leaks in C++ programs"
HOMEPAGE="http://www.andreasen.org/LeakTracer/"
SRC_URI="mirror://gentoo/${P}-gentoo_p${PATCH_LEVEL}.tbz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=dev-lang/perl-5
	sys-devel/gdb"
RDEPEND="${DEPEND}"

# leaktracer is being realized using LD_PRELOAD and segfaults
# when being run in the sandbox and the library is _not_ in
# /usr/$(get_libdir) which is not possible before installation
RESTRICT="test"

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_SOURCE="${WORKDIR}/patches"
	EPATCH_SUFFIX="patch"
	epatch

	sed -i \
		-e "s|%LIBDIR%|$(get_libdir)|" \
		LeakCheck || die "sed for setting lib path failed"
}

src_compile() {
	emake CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dobin LeakCheck leak-analyze || die "dobin failed"
	dolib.so LeakTracer.so || die "dolib.so failed"
	dohtml README.html
	dodoc README test.cc
}

pkg_postinst() {
	elog "To use LeakTracer, run LeakCheck my_prog and then leak-analyze my_prog leak.out"
	elog "Please reffer to README file for more info."
}
