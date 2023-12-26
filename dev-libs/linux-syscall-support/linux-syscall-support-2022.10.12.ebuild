# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Linux Syscall Support"
HOMEPAGE="https://chromium.googlesource.com/linux-syscall-support"
SRC_URI="https://chromium.googlesource.com/${PN}/+archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="
	${DEPEND}
"
BDEPEND=""

S="${WORKDIR}"

src_prepare() {
	default
	sed -i -e "/fallocate/d" tests/Makefile || die
	mkdir lss || die
	cp linux_syscall_support.h lss/ || die
}

src_test() {
	emake -C tests
}

src_install() {
	doheader -r lss
}
