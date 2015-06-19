# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/iniparser/iniparser-3.1-r1.ebuild,v 1.14 2015/06/09 10:46:25 grobian Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils autotools-multilib

DESCRIPTION="A free stand-alone ini file parsing library"
HOMEPAGE="http://ndevilla.free.fr/iniparser/"

SRC_URI="http://ndevilla.free.fr/iniparser/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples static-libs"

DEPEND="doc? ( app-doc/doxygen )
		sys-devel/libtool"
RDEPEND=""

# the tests are rather examples than tests, no point in running them
RESTRICT="test"

S="${WORKDIR}/${PN}"

DOCS=( AUTHORS README )

PATCHES=(
	"${FILESDIR}/${PN}-3.0b-cpp.patch"
	"${FILESDIR}/${PN}-3.0-autotools.patch"
)

src_install() {
	autotools-multilib_src_install

	if use doc; then
		emake -C doc
		dohtml -r html/*
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins test/*.{c,ini,py}
	fi
}
