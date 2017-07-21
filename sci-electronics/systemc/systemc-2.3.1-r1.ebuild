# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs autotools-utils
MY_P="${P}a"

DESCRIPTION="A C++ based modeling platform for VLSI and system-level co-design"
HOMEPAGE="http://accellera.org/community/systemc"
SRC_URI="http://accellera.org/images/downloads/standards/${PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
IUSE="doc static-libs"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

AUTOTOOLS_IN_SOURCE_BUILD=1

S="${WORKDIR}/${MY_P}"

src_prepare() {
	for sfile in src/sysc/qt/md/*.s ; do
		sed -i -e '$a \
#if defined(__linux__) && defined(__ELF__) \
.section .note.GNU-stack,"",%progbits \
#endif' "${sfile}" || die "Patching ${sfile} failed"
	done
}

src_configure() {
	econf $(use_enable static-libs static) CXX=$(tc-getCXX)\
	--with-unix-layout
}

src_install() {
	dodoc AUTHORS ChangeLog INSTALL NEWS README RELEASENOTES
	rm docs/Makefile* || die
	use doc && dodoc -r docs/*
	cd src
	autotools-utils_src_install
}

pkg_postinst() {
	elog "If you want to run the examples, you need to :"
	elog "    tar xvfz ${PORTAGE_ACTUAL_DISTDIR}/${A}"
	elog "    cd ${MY_P}"
	elog "    find examples -name 'Makefile.*' -exec sed -i -e 's/-lm/-lm -lpthread/' '{}' \;"
	elog "    ./configure"
	elog "    cd examples"
	elog "    make check"
}
