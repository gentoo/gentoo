# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_PN=${PN^^}

DESCRIPTION="Jisyo (dictionary) files for the SKK Japanese-input software"
HOMEPAGE="http://openlab.ring.gr.jp/skk/dic.html"
SRC_URI="mirror://gentoo/${P}.tar.xz
	https://dev.gentoo.org/~hattya/distfiles/${P}.tar.xz"

LICENSE="GPL-2 freedist public-domain"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="cdb"

DEPEND="virtual/awk
	cdb? (
		|| (
			dev-db/tinycdb
			dev-db/cdb
		)
	)"
RDEPEND=""

DOCS=( ChangeLog{,.{1..3}} READMEs/committers.txt edict_doc.txt zipcode/README.ja )

src_prepare() {
	rm -f ${MY_PN}.{wrong*,noregist,not_wrong,hukugougo,notes,requested,pubdic+}

	eapply_user
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
}
