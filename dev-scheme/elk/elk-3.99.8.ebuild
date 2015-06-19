# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/elk/elk-3.99.8.ebuild,v 1.1 2012/11/07 14:05:32 hkbst Exp $

EAPI="4"

DESCRIPTION="Scheme implementation designed to be embeddable extension to C/C++ applications"
HOMEPAGE="http://sam.zoy.org/elk"
SRC_URI="http://sam.zoy.org/elk/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""

src_compile() {
	# parallel build is broken
	emake -j1 || die "Make failed!"
}

# tests are run automatically during make and fail with default src_test
src_test() {
	echo "Tests already run during compile"
}

src_install() {
	# parallel install is broken
	emake -j1 DESTDIR="${D}" install || die "Install failed"
}
