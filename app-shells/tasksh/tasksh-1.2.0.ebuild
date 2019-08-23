# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Tasksh is a shell for Taskwarrior"
HOMEPAGE="https://taskwarrior.org/"
SRC_URI="https://taskwarrior.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="app-misc/task
	sys-libs/readline:0"
RDEPEND="${DEPEND}"

src_prepare() {
	      cmake-utils_src_prepare
}

src_configure() {
		mycmakeargs=(
			-DTASKSH_DOCDIR=share/doc/${PF}
			-DTASKSH_RCDIR=share/${PN}/rc
		)
		cmake-utils_src_configure
}

src_install() {
	      cmake-utils_src_install
}
