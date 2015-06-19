# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/libsparse/libsparse-4.4.4.1.ebuild,v 1.2 2014/07/30 16:34:14 jauhien Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Library and cli tools for Android sparse files"
HOMEPAGE="https://android.googlesource.com/platform/system/core"
SRC_URI="http://dev.gentoo.org/~jauhien/distfiles/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"

RDEPEND="${PYTHON_DEPS}"

src_prepare() {
	cp "${FILESDIR}/Makefile" "${S}"
}

src_install() {
	default

	python_doscript simg_dump.py
}
