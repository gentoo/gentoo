# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="a set of command-line programs providing a simple interface to inotify"
HOMEPAGE="https://github.com/inotify-tools/inotify-tools"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~sparc ~x86"
IUSE="doc"

BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default

	# Remove -Werror from CFLAGS (#745069)
	find -name "Makefile.am" -print0 \
		| xargs --null sed 's@ -Werror@@' -i || die

	eautoreconf
}

src_configure() {
	# only docs installed are doxygen ones, so use /html
	local myeconfargs=(
		--disable-static
		--docdir='$(datarootdir)'/doc/${PF}/html
		$(use_enable doc doxygen)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
