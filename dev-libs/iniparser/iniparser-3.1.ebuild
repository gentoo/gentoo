# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/iniparser/iniparser-3.1.ebuild,v 1.11 2014/08/10 20:34:17 slyfox Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="A free stand-alone ini file parsing library"
HOMEPAGE="http://ndevilla.free.fr/iniparser/"

SRC_URI="http://ndevilla.free.fr/iniparser/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x86-macos"
IUSE="doc examples static-libs"

DEPEND="doc? ( app-doc/doxygen )
		sys-devel/libtool"
RDEPEND=""

# the tests are rather examples than tests, no point in running  them
RESTRICT="test"

S="${WORKDIR}/${PN}"

DOCS=( AUTHORS README )

PATCHES=(
	"${FILESDIR}/${PN}-3.0b-cpp.patch"
	"${FILESDIR}/${PN}-3.0-autotools.patch"
)

src_install() {
	autotools-utils_src_install

	if use doc; then
		emake -C doc
		dohtml -r html/*
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins test/*.{c,ini,py}
	fi
}
