# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gumbo/gumbo-0.9.2.ebuild,v 1.2 2014/12/25 08:46:29 graaff Exp $

EAPI=5

inherit autotools

DESCRIPTION="An implementation of the HTML5 parsing algorithm implemented as a pure C99 library"
HOMEPAGE="https://github.com/google/gumbo-parser#readme"
SRC_URI="https://github.com/google/gumbo-parser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="doc test"

S="${WORKDIR}/gumbo-parser-${PV}"

DEPEND="test? ( dev-cpp/gtest )
	doc? ( app-doc/doxygen )"

src_prepare() {
	eautoreconf
}

src_compile() {
	default

	if use doc; then
		doxygen || die "doxygen failed"
	fi
}

src_install() {
	default

	if use doc; then
		dohtml -r docs/html/.
		for page in docs/man/man3/* ; do
			doman ${page}
		done
	fi
}
