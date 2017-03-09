# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A dotfile manager for the config files in your home folder"
HOMEPAGE="https://github.com/TheLocehiliosan/yadm/"
SRC_URI="https://github.com/TheLocehiliosan/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DOCS=( CHANGES CONTRIBUTORS README.md )

DEPEND="
	test? (
		dev-tcltk/expect
		dev-util/bats
		dev-vcs/git
	)"
RDEPEND="
	app-crypt/gnupg
	dev-vcs/git"

src_compile() {
	emake yadm.md
}

src_test() {
	# 109_accept_encryption tests are interactive, thus fail. Skip them
	while IFS="" read -d $'\0' -r f ; do
		bats "${f}" || die "Test ${f} failed"
	done < <(find test -name '*.bats' -and -not -name '109_accept_encryption.bats' -print0)
}

src_install() {
	einstalldocs

	dobin "${PN}"
	doman "${PN}.1"
}
