# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit autotools python-any-r1

DESCRIPTION="Standard front-end for writing C++ programs that use PostgreSQL"
HOMEPAGE="https://pqxx.org/development/libpqxx/"
SRC_URI="https://github.com/jtv/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
# SONAME version is equal to major.minor
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc static-libs"

RDEPEND="dev-db/postgresql:="
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	doc? (
		app-text/doxygen[dot]
		app-text/xmlto
	)
"

DOCS=( AUTHORS NEWS README.md )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable doc documentation) \
		$(use_enable static-libs static)
}

src_test() {
	einfo "Preparing postgres test instance"
	initdb --pgdata="${T}/pgsql" || die
	pg_ctl --wait --pgdata="${T}/pgsql" start \
		--options="-h '' -k '${T}'" || die
	createdb --host="${T}" pqxx_test || die

	local -x PGDATABASE="pqxx_test" PGHOST="${T}"
	local ret=0
	if cd "${S}/test" ; then
		nonfatal emake check || ret=$?
	else
		# eww but need to ensure that we don't clash with exit code from tests
		ret="cd_failed"
	fi

	einfo "Stopping postgres test instance"
	pg_ctl --wait --pgdata="${T}/pgsql" stop || die

	[[ "${ret}" == "cd_failed" ]] && die "could not change to test directory"
	(( ret != 0 )) && die "Tests failed!"
}

src_install () {
	use doc && HTML_DOCS=( doc/doxygen-html/. )
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
