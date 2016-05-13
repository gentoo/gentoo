# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
USE_RUBY="ruby20 ruby21"

inherit cvs ruby-single

MY_PN=${PN^^}

DESCRIPTION="Jisyo (dictionary) files for the SKK Japanese-input software"
HOMEPAGE="http://openlab.ring.gr.jp/skk/dic.html"
ECVS_SERVER="openlab.jp:/circus/cvsroot"
ECVS_MODULE="skk/dic"
ECVS_USER="guest"
ECVS_PASS="guest"

LICENSE="GPL-2 freedist public-domain"
SLOT="0"
KEYWORDS=""
IUSE="cdb"

DEPEND="${RUBY_DEPS}
	app-i18n/skktools
	sys-apps/gawk
	cdb? (
		|| (
			dev-db/tinycdb
			dev-db/cdb
		)
	)"
RDEPEND=""
S="${WORKDIR}/${ECVS_MODULE}"

DOCS=( ChangeLog{,.{1..3}} READMEs/committers.txt edict_doc.txt zipcode/README.ja )

SKKTOOLS_DIR="${EPREFIX}/usr/share/skktools/convert2skk"

src_prepare() {
	rm -f ${MY_PN}.{wrong*,noregist,not_wrong,hukugougo,notes,requested,pubdic+}

	eapply_user
}

src_compile() {
	local ctdic="${MY_PN}.china_taiwan" ruby
	mv ${ctdic}{.header,}
	for ruby in ${USE_RUBY}; do
		if has_version dev-lang/ruby:${ruby:4:1}.${ruby:5}; then
			${ruby} ${SKKTOOLS_DIR}/ctdicconv.rb csv/${ctdic##*.}.csv | skkdic-expr2 >> ${ctdic}
			break
		fi
	done

	if use cdb; then
		local cdbmake="cdbmake" f
		if has_version dev-db/tinycdb; then
			cdbmake="cdb -c"
		fi
		for f in {,zipcode/}${MY_PN}.*; do
			LC_ALL=C gawk '
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
