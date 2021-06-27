# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A tool like sed, awk, cut, join, and sort for name-indexed data (CSV, JSON, ..)"
HOMEPAGE="https://miller.readthedocs.io https://github.com/johnkerl/miller"
SRC_URI="https://github.com/johnkerl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="sys-devel/flex"

BDEPEND="doc? (
		dev-lang/ruby
		dev-python/sphinx
	)"

src_prepare() {
	default

	# respect flags
	find -type f -name "Makefile.am" -exec sed -i -r -e '/.*FLAGS[^=]*=/ s:(-g|-pg|-O[0-9]) ::g' -- {} \; || die

	if use doc; then
		# disable rebuilding of man pages
		sed -ri '/\s+mkman(\.rb)?\s+/d' docs/Makefile || die \
			"Cannot disable rebuilding of man pages"

		# missing file in v5.10.0
		cp "${FILESDIR}/sort-within-records.json" docs/data/ || die \
			"Cannot copy file to docs/data"

		# shell script replacement for John Kerl's perl script
		cp "${FILESDIR}/creach" docs/ || die \
			"Cannot copy creach shell script"
		chmod +x docs/creach || die \
			"Cannot set creach shell script executable bit"
	fi

	# disable building tests automagically
	if ! use test; then
		sed -e '/SUBDIRS[^=]*=/ s:[^ ]*_test::g' -i -- c/Makefile.am || die
	fi

	eautoreconf
}

src_compile() {
	emake

	if use doc; then
		PATH="${S}/c:${S}/docs:${PATH}" emake -C docs html
	fi
}

src_test() {
	emake -C c/reg_test
	emake -C c/unit_test
}

src_install() {
	local HTML_DOCS=( $(usex doc docs/_build/html/.) )

	default

	doman 'docs/mlr.1'
}
