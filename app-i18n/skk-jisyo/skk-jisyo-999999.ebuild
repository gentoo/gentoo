# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
USE_RUBY="ruby24 ruby25 ruby26"

inherit git-r3 ruby-single

MY_PN=${PN^^}

DESCRIPTION="Jisyo (dictionary) files for the SKK Japanese-input software"
HOMEPAGE="https://skk-dev.github.io/dict"
EGIT_REPO_URI="https://github.com/skk-dev/dict"

LICENSE="GPL-2 freedist public-domain"
SLOT="0"
KEYWORDS=""
IUSE="cdb ${USE_RUBY//ruby/ruby_targets_ruby}"

DEPEND="${RUBY_DEPS}
	app-i18n/skktools
	virtual/awk
	cdb? (
		|| (
			dev-db/tinycdb
			dev-db/cdb
		)
	)"
RDEPEND=""

DOCS=( ChangeLog{,.{1..3}} committers.txt edict_doc.txt )

SKKTOOLS_DIR="${EPREFIX}/usr/share/skktools/convert2skk"

src_prepare() {
	rm -f ${MY_PN}.{wrong*,noregist,not_wrong,hukugougo,notes,requested,pubdic+}

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
