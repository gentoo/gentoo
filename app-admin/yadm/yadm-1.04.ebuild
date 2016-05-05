# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
		dev-util/bats
		dev-vcs/git
	)"
RDEPEND="dev-vcs/git
	app-crypt/gnupg"

src_test() {
	# 109_accept_encryption tests are interactive, thus fail. Skip them
	bats $(find test/ -type f -name '*.bats' -and -not -name '109_accept_encryption.bats') \
		|| die "Tests failed"
}

src_install() {
	einstalldocs

	dobin yadm
	doman yadm.1
}
