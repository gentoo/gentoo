# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake vcs-snapshot

DESCRIPTION="A interpreted language mainly used for games"
HOMEPAGE="http://squirrel-lang.org/"
commit=40050fa249733c85485adde533774ec066d29aca
SRC_URI="https://github.com/albertodemichelis/squirrel/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/albertodemichelis/squirrel/archive/${commit}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(usex static-libs '' -DDISABLE_STATIC=YES)
		# /usr/bin/sq is used by app-text/ispell
		# /usr/lib/libsquirrel.so is used by app-shells/squirrelsh
		-DLONG_OUTPUT_NAMES=YES
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc HISTORY

	if use examples; then
		docompress -x /usr/share/doc/${PF}/samples
		dodoc -r samples
	fi
}
