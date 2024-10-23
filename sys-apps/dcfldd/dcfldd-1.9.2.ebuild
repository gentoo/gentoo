# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools bash-completion-r1

DESCRIPTION="enhanced dd with features for forensics and security"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/dcfldd"
SRC_URI="https://github.com/resurrecting-open-source-projects/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

DEPEND="virtual/pkgconfig"

DOCS=(
	AUTHORS
	CONTRIBUTING.md
	ChangeLog
	NEWS
	README.md
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --with-bash-completion
}

src_install() {
	default

	# Fix Bash completion filename
	mv "${D}$(get_bashcompdir)"/dcfldd{-bash_completion,} || die
}
