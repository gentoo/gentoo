# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/systemc/systemc-2.2.0-r2.ebuild,v 1.1 2012/04/26 15:40:20 jlec Exp $

EAPI=4

inherit versionator multilib toolchain-funcs

DESCRIPTION="A C++ based modeling platform for VLSI and system-level co-design"
HOMEPAGE="http://www.systemc.org/"
SRC_URI="${P}.tgz"

SLOT="0"
LICENSE="SOPLA-2.3"
IUSE=""
KEYWORDS="~amd64 ~x86"

RESTRICT="fetch test"

pkg_nofetch() {
	elog "${PN} developers require end-users to accept their license agreement"
	elog "by registering on their Web site (${HOMEPAGE})."
	elog "Please download ${A} manually and place it in ${DISTDIR}."
}

src_prepare() {
	sed -i -e "s:lib-\$(TARGET_ARCH):$(get_libdir):g" $(find . -name Makefile.in) || die "Patching Makefile.in failed"

	sed -i -e "s:OPT_CXXFLAGS=\"-O3\":OPT_CXXFLAGS=\"${CXXFLAGS}\":g" configure || die "Patching configure failed"

	sed -i -e '/#include "sysc\/utils\/sc_report.h"/a \
#include <cstdlib> \
#include <cstring>' src/sysc/utils/sc_utils_ids.cpp  || die "Patching failed"

	for sfile in src/sysc/qt/md/*.s ; do
		sed -i -e '$a \
#if defined(__linux__) && defined(__ELF__) \
.section .note.GNU-stack,"",%progbits \
#endif' "${sfile}" || die "Patching ${sfile} failed"
	done
}

src_configure() {
	econf --disable-dependency-tracking CXX=$(tc-getCXX)
}

src_compile() {
	cd src
	default
}

src_install() {
	dodoc AUTHORS ChangeLog INSTALL NEWS README RELEASENOTES
	doins -r docs
	cd src
	default
}

pkg_postinst() {
	elog "If you want to run the examples, you need to :"
	elog "    tar xvfz ${PORTAGE_ACTUAL_DISTDIR}/${A}"
	elog "    cd ${P}"
	elog "    find examples -name 'Makefile.*' -exec sed -i -e 's/-lm/-lm -lpthread/' '{}' \;"
	elog "    ./configure"
	elog "    cd examples"
	elog "    make check"
}
