# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Integrated Full-Text-Search for Japanese language using morphological analyze"
HOMEPAGE="http://textsearch-ja.projects.postgresql.org/index.html"
SRC_URI="http://pgfoundry.org/frs/download.php/2943/textsearch_ja-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-text/mecab
		>=dev-db/postgresql-7.4[server]" # pgmecab requires PGXS
RDEPEND="${DEPEND}"

src_compile() {
	emake USE_PGXS=1
}

src_install() {
	emake DESTDIR="${D}" USE_PGXS=1 install
}
