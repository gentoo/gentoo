# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Tool to ease merging Pull Requests and git patches"
HOMEPAGE="https://github.com/projg2/pram/"
SRC_URI="
	https://github.com/projg2/pram/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 ~riscv x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-vcs/git
	net-misc/wget[ssl]
	virtual/editor
"
BDEPEND="
	test? (
		${RDEPEND}
		app-crypt/gnupg
		>=dev-vcs/git-2.45.0
		sys-apps/diffutils
	)
"
