# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="A high-level Emacs Lisp RDBMS front-end"
HOMEPAGE="https://github.com/magit/emacsql"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}.git"
else
	SRC_URI="
		https://github.com/magit/${PN}/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz
	"

	KEYWORDS="amd64"
fi

LICENSE="Unlicense"
SLOT="0"
# TODO(arsen): postgres-pg using app-emacs/pg (unpackaged as of yet)
IUSE="postgres mysql"

RDEPEND="
	${DEPEND}
	postgres? (
		dev-db/postgresql
	)
	mysql? (
		virtual/mysql
	)
"
BDEPEND="
	virtual/pkgconfig
"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	# Not packaged.
	rm emacsql-pg.el || die

	local -A backends=(
		[postgres]=psql
		[mysql]=mysql
	)

	for useflag in "${!backends[@]}"; do
		if ! use "${useflag}"; then
			rm emacsql-"${backends[${useflag}]}".el || die
		fi
	done
}
