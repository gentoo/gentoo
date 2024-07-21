# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN=${PN^^}

DESCRIPTION="Jisyo (dictionary) files for the SKK Japanese-input software"
HOMEPAGE="https://skk-dev.github.io/dict/"
SRC_URI="mirror://gentoo/${P}.tar.xz
	https://dev.gentoo.org/~hattya/distfiles/${P}.tar.xz"

LICENSE="CC-BY-SA-3.0 GPL-2+ public-domain unicode"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cdb"

DEPEND="app-alternatives/awk
	cdb? (
		|| (
			dev-db/tinycdb
			dev-db/cdb
		)
	)"
RDEPEND=""

DOCS=( ChangeLog{,.{1..3}} committers.md )
HTML_DOCS=( edict_doc.html )

src_prepare() {
	rm -f ${MY_PN}.{hukugougo,noregist,notes,pubdic+,requested,unannotated,*wrong*}

	default
}

cdb_make() {
	cdbmake "${1}" "${1}.tmp"
}

tinycdb_make() {
	cdb -c "${1}"
}

src_compile() {
	if use cdb; then
		local cdbmake=cdb_make f
		if has_version dev-db/tinycdb; then
			cdbmake=tinycdb_make
		fi
		for f in {,zipcode/}${MY_PN}.*; do
			LC_ALL=C awk '
				/^[^;]/ {
					s = substr($0, index($0, " ") + 1)
					print "+" length($1) "," length(s) ":" $1 "->" s
				}
				END {
					print ""
				}
			' ${f} | ${cdbmake} ${f}.cdb || die
		done
	fi
}

src_install() {
	insinto /usr/share/skk
	doins {,zipcode/}${MY_PN}.*

	einstalldocs
	docinto zipcode
	dodoc zipcode/README.md
}
