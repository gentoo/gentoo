# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A fulltext search engine for Tokyo Cabinet"
HOMEPAGE="https://fallabs.com/tokyodystopia/"
SRC_URI="https://fallabs.com/tokyodystopia/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="dev-db/tokyocabinet"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/fix_rpath.patch"
	"${FILESDIR}/fix_ldconfig.patch"
	"${FILESDIR}/remove_docinst.patch"
)

src_configure() {
	econf --libexecdir="${EPREFIX}"/usr/libexec/${PN}
}

src_install() {
	HTML_DOCS=( doc/. )

	default

	if use examples; then
		insinto /usr/share/${PF}/example
		doins example/.
	fi
}

src_test() {
	emake -j1 check
}
