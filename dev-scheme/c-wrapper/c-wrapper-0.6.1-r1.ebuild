# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="Foreign function interface for C and Objective-C libraries"
HOMEPAGE="http://www.koguro.net/prog/c-wrapper/"
SRC_URI="http://www.koguro.net/prog/${PN}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ia64 x86"
IUSE="examples"

RDEPEND="dev-scheme/gauche:=
	virtual/libffi"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-closure.patch
	"${FILESDIR}"/${PN}-gcc-5.patch
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-glibc-2.25.patch
	"${FILESDIR}"/${PN}-info.patch
)
HTML_DOCS=( doc/${PN}-ref{e,j}.html )

src_prepare() {
	default
	eautoreconf
}

src_test() {
	emake -j1 -s check
}

src_install() {
	default

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
