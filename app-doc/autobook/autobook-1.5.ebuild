# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="GNU Autoconf, Automake and Libtool"
HOMEPAGE="https://sourceware.org/autobook/"
SRC_URI="https://sourceware.org/autobook/${P}.tar.gz
	examples? (
		https://sourceware.org/autobook/foonly-2.0.tar.gz
		https://sourceware.org/autobook/small-2.0.tar.gz
		https://sourceware.org/autobook/hello-2.0.tar.gz
		https://sourceware.org/autobook/convenience-2.0.tar.gz
	)"

LICENSE="OPL"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 m68k ppc s390 sh x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

src_install() {
	dohtml * || die
	if use examples ; then
		local d
		for d in {convenience,foonly,hello,small}-2.0 ; do
			insinto /usr/share/doc/${PF}/${d}
			doins -r "${WORKDIR}"/${d}/* || die "doins ${d} failed"
		done
	fi
}
