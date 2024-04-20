# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

inherit git-r3 ruby-single

MY_PN=${PN^^}

DESCRIPTION="Jisyo (dictionary) files for the SKK Japanese-input software"
HOMEPAGE="http://openlab.ring.gr.jp/skk/dic.html"
EGIT_REPO_URI="https://github.com/skk-dev/dict"

LICENSE="CC-BY-SA-3.0 GPL-2+ public-domain unicode"
SLOT="0"
KEYWORDS=""
IUSE="cdb ${USE_RUBY//ruby/ruby_targets_ruby}"

DEPEND="${RUBY_DEPS}
	app-i18n/skktools
	app-alternatives/awk
	cdb? (
		|| (
			dev-db/tinycdb
			dev-db/cdb
		)
	)"
RDEPEND=""

DOCS=( ChangeLog{,.{1..3}} committers.md )
HTML_DOCS=( edict_doc.html )

SKKTOOLS_DIR="${EPREFIX}/usr/share/skktools/convert2skk"

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
	local ctdic="${MY_PN}.china_taiwan" ruby
	mv ${ctdic}{.header,}
	for ruby in ${RUBY_TARGETS_PREFERENCE}; do
		if use ruby_targets_${ruby}; then
			${ruby} ${SKKTOOLS_DIR}/ctdicconv.rb csv/${ctdic##*.}.csv | skkdic-expr2 >> ${ctdic}
			break
		fi
	done

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
