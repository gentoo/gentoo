# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module

DESCRIPTION="A backup program that is fast, efficient and secure"
HOMEPAGE="https://restic.github.io/"

SRC_URI="https://github.com/restic/restic/releases/download/v${PV}/${P}.tar.gz
	https://gentoo.kropotkin.rocks/go-pkgs/restic-0.14.0-vendor.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 LGPL-3-with-linking-exception MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="sys-fs/fuse:0"
DEPEND="${RDEPEND}"

src_compile() {
	local mygoargs=(
		-v
		-work
		-x
		-tags release
		-ldflags "-X main.version=${PV}"
		-asmflags "-trimpath=${S}"
		-gcflags "-trimpath=${S}"
	)

	ego build "${mygoargs[@]}" -o restic ./cmd/restic || die
}

src_test() {
	RESTIC_TEST_FUSE=0 go test -timeout 30m -v -work -x ./cmd/... ./internal/... || die
}

src_install() {
	dobin restic

	newbashcomp doc/bash-completion.sh "${PN}"

	insinto /usr/share/zsh/site-functions
	newins doc/zsh-completion.zsh _restic

	doman doc/man/*
	dodoc doc/*.rst
}
