# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Tool to ease merging Pull Requests and git patches"
HOMEPAGE="https://github.com/mgorny/pram"
SRC_URI="https://github.com/mgorny/pram/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-vcs/git
	net-misc/wget[ssl]
	virtual/editor
	!dev-perl/Gentoo-App-Pram"
DEPEND="
	test? (
		${RDEPEND}
		app-crypt/gnupg
		sys-apps/diffutils
	)"
