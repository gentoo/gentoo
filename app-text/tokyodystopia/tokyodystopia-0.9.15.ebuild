# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A fulltext search engine for Tokyo Cabinet"
HOMEPAGE="http://fallabs.com/tokyodystopia/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="dev-db/tokyocabinet"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.15-fix-rpath.patch
	"${FILESDIR}"/${PN}-0.9.15-fix-ldconfig.patch
	"${FILESDIR}"/${PN}-0.9.15-remove-docinst.patch
)

src_configure() {
	econf --libexecdir=/usr/libexec/${PN} || die
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	HTML_DOCS="doc/." einstalldocs

	if use examples; then
		insinto /usr/share/${PF}/example
		doins example/* || die "Install failed"
	fi

}

src_test() {
	emake -j1 check || die "Tests failed"
}
