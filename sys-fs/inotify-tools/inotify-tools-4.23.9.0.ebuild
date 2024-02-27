# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Set of command-line programs providing a simple interface to inotify"
HOMEPAGE="https://github.com/inotify-tools/inotify-tools/"
SRC_URI="
	https://github.com/inotify-tools/inotify-tools/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ~riscv sparc x86"
IUSE="doc"

BDEPEND="doc? ( app-text/doxygen )"

src_prepare() {
	default

	sed -i 's/ -Werror//' {,libinotifytools/}src/Makefile.am || die #745069

	eautoreconf
}

src_configure() {
	local econfargs=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}/html
		$(use_enable doc doxygen)
	)

	econf "${econfargs[@]}"
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
