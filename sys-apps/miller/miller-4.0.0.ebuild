# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="A tool like sed, awk, cut, join, and sort for name-indexed data (CSV, JSON, ..)"
HOMEPAGE="http://johnkerl.org/miller"
LICENSE="BSD-2"

SLOT="0"
SRC_URI="https://github.com/johnkerl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc test"

DEPEND="sys-devel/flex"

my_for_each_test_dir() {
	local test_dirs=( c/{reg,unit}_test )
	if use test ; then
		for d in "${test_dirs[@]}" ; do
			pushd "${d}" >/dev/null || die
			"${@}" || die
			popd >/dev/null || die
		done
	fi
}

src_prepare() {
	default

	local sed_args=(
		# respect FLAGS
		-e '/.*FLAGS[^=]*=/ s:(-g|-pg|-O[0-9]) ::g'
	)
	find -type f -name "Makefile.am" | xargs sed -r "${sed_args[@]}" -i --
	assert

	# disable docs rebuilding as they're shipped prebuilt
	sed -e '/SUBDIRS[^=]*=/ s:doc::g' -i -- Makefile.am || die

	# disable building tests automagically
	use test || sed -e '/SUBDIRS[^=]*=/ s:[^ ]*_test::g' -i -- c/Makefile.am || die

	eautoreconf
}

src_test() {
	my_for_each_test_dir emake check
}

src_install() {
	local HTML_DOCS=( $(usev doc) )

	default
}
