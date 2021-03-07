# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Integrated Full-Text-Search for Japanese language using morphological analyze"
HOMEPAGE="http://textsearch-ja.projects.postgresql.org/index.html"
SRC_URI="http://pgfoundry.org/frs/download.php/2943/textsearch_ja-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-text/mecab
	>=dev-db/postgresql-7.4:*[server]" # pgmecab requires PGXS
RDEPEND="${DEPEND}"

src_compile() {
	emake USE_PGXS=1
}

src_install() {
	emake DESTDIR="${D}" USE_PGXS=1 install
}
