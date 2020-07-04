# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Colored, side-by-side diff terminal viewer"
HOMEPAGE="https://github.com/ymattw/cdiff"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND="dev-util/ydiff"

S="${WORKDIR}"

src_install() {
	dosym ydiff /usr/bin/cdiff
}
