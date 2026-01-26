# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# commit as of $PV from stable-202601 branch
GIT_TAG="2a288c048e2a23ea9cd8cbef9a60aa4ac82bdc3d"

DESCRIPTION="Library of common routines intended to be shared"
HOMEPAGE="https://www.gnu.org/software/gnulib"
SRC_URI="https://codeberg.org/gnulib/gnulib/archive/${GIT_TAG}.tar.gz -> ${PN}-${GIT_TAG}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3+ LGPL-2.1+ FDL-1.3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="doc"

src_compile() {
	if use doc; then
		emake -C doc info html
	fi
}

src_install() {
	dodoc README ChangeLog

	insinto /usr/share/${PN}
	doins -r build-aux
	doins -r doc
	doins -r lib
	doins -r m4
	doins -r modules
	doins -r tests
	doins -r top

	# install the real script
	exeinto /usr/share/${PN}
	doexe gnulib-tool.sh

	# we cannot use the .py impl because it python-exec badly interacts,
	# so we drop it, and force the .sh version; it's not that it matters
	# a whole lot, since this is supposed to be run occasionally

	# create and install the wrapper
	dosym ../share/${PN}/gnulib-tool.sh /usr/bin/gnulib-tool
}
