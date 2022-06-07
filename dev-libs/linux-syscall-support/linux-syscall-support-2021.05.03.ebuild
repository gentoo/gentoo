# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CommitId=242f0729ac827a50ac7338e45c9f373eb73e4ca9

DESCRIPTION="Linux Syscall Support"
HOMEPAGE="https://github.com/mikey/linux-syscall-support/"
SRC_URI="https://github.com/mikey/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="
	${DEPEND}
"
BDEPEND=""

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${P}-test.patch
)

src_prepare() {
	default
	mkdir lss || die
	cp linux_syscall_support.h lss/ || die
}

src_test() {
	emake -C tests
}

src_install() {
	doheader -r lss
}
