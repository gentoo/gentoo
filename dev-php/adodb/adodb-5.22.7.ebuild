# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ADOdb"
DESCRIPTION="Database abstraction layer for PHP"
HOMEPAGE="https://adodb.org/ https://github.com/ADOdb/ADOdb"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"

# If you want to be picky, we should require that PHP be built with at
# least one database driver enabled; otherwise adodb isn't going to be
# able to do anything. But, the database USE flags for dev-lang/php are
# a mess. What we would *like* to do is have a set of USE flags for
# adodb that then propagate to PHP itself... for example, adodb[mysql]
# could require php[mysql]. To do that would require that we duplicate
# the database USE flag mess for adodb -- not desirable. Instead we punt
# and let the user install adodb unconditionally. If he doesn't have
# database support in PHP, it just won't work.
RDEPEND="dev-lang/php:*"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	DOCS="README.md docs/changelog*.md xmlschema*.dtd session/*.sql"
	DOCS+=" session/*.txt session/*.xml pear/auth_adodb_example.php"
	DOCS+=" pear/readme.Auth.txt"

	dodoc ${DOCS}
	rm -f ${DOCS} || die "failed to remove docs before installation"

	insinto "/usr/share/php/${PN}"
	doins *.php
	doins -r datadict drivers lang pear perf session xsl
}
