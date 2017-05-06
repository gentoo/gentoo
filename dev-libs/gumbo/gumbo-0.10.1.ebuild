# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools

DESCRIPTION="The HTML5 parsing algorithm implemented as a pure C99 library"
HOMEPAGE="https://github.com/google/gumbo-parser#readme"
SRC_URI="https://github.com/google/gumbo-parser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

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
