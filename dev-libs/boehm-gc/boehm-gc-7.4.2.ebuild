# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_P="gc-${PV}"

DESCRIPTION="The Boehm-Demers-Weiser conservative garbage collector"
HOMEPAGE="http://www.hboehm.info/gc/"
SRC_URI="http://www.hboehm.info/gc/gc_source/${MY_P}.tar.gz"

LICENSE="boehm-gc"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="cxx static-libs threads"

DEPEND=">=dev-libs/libatomic_ops-7.4
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local config=(
		--with-libatomic-ops
		$(use_enable cxx cplusplus)
		$(use_enable static-libs static)
		$(use threads || echo --disable-threads)
	)
	econf "${config[@]}"
}

src_compile() {
	# Workaround build errors. #574566
	use ia64 && emake src/ia64_save_regs_in_stack.lo
	use sparc && emake src/sparc_mach_dep.lo
	default
}

src_install() {
	default
	use static-libs || prune_libtool_files

	rm -r "${ED}"/usr/share/gc || die
	dodoc README.QUICK doc/README{.environment,.linux,.macros}
	dohtml doc/*.html
	newman doc/gc.man GC_malloc.1
}
