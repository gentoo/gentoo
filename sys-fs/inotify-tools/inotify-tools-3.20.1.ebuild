# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="a set of command-line programs providing a simple interface to inotify"
HOMEPAGE="https://github.com/rvoicilas/inotify-tools/wiki"
SRC_URI="https://github.com/rvoicilas/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 hppa ~mips sparc x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# only docs installed are doxygen ones, so use /html
	local myeconfargs=(
		--docdir='$(datarootdir)'/doc/${PF}/html
		$(use_enable doc doxygen)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED%/}" \( -name '*.a*' -o -name '*.la' \) -delete || die
}
