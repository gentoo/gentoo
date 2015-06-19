# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/distorm64/distorm64-1.7.30-r1.ebuild,v 1.3 2009/11/22 18:55:26 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit eutils flag-o-matic python toolchain-funcs

DESCRIPTION="The ultimate disassembler library (X86-32, X86-64)"
HOMEPAGE="http://www.ragestorm.net/distorm/"
SRC_URI="http://ragestorm.net/distorm/${PN}-pkg${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+python"

DEPEND="python? ( >=dev-lang/python-2.4 )"
RDEPEND="${DEPEND}"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/${P}-python.patch"
	epatch "${FILESDIR}/${P}-respect_flags.patch"
}

src_compile() {
	cd "${WORKDIR}/${PN}/build/linux"
	emake CC="$(tc-getCC)" clib || die "emake clib failed"

	if use python; then
		building() {
			# Build ../../src/pydistorm.o separately with each enabled version of Python.
			rm -f ../../src/pydistorm.o

			# Additional CFLAGS retrieved from build/linux/Makefile.
			emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -I$(python_get_includedir) -Wall -fPIC -DSUPPORT_64BIT_OFFSET -D_DLL" TARGET="distorm.so-${PYTHON_ABI}" py
		}
		python_execute_function building
	fi

	cd "${WORKDIR}/${PN}/linuxproj"
	emake CC="$(tc-getCC)" disasm || die "emake disasm failed"

}

src_install() {
	cd "${WORKDIR}/${PN}/build/linux"

	dolib.so libdistorm64.so

	if use python; then
		installation() {
			dodir "$(python_get_sitedir)"
			install distorm.so-${PYTHON_ABI} "${D}$(python_get_sitedir)/distorm.so"
		}
		python_execute_function -q installation
	fi

	cd "${WORKDIR}/${PN}"
	newlib.a distorm64.a libdistorm64.a

	dobin linuxproj/disasm

	dodir "/usr/include"
	install distorm.h "${D}usr/include/" || die "Unable to install distorm.h"
}
