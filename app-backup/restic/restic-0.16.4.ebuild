# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="A backup program that is fast, efficient and secure"
HOMEPAGE="https://restic.github.io/"
SRC_URI="https://github.com/restic/restic/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 LGPL-3-with-linking-exception MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~ppc64 ~riscv x86"

RDEPEND="sys-fs/fuse:0"
DEPEND="${RDEPEND}"

src_compile() {
	local mygoargs=(
		-tags release
		-ldflags "-X main.version=${PV}"
		-asmflags "-trimpath=${S}"
		-gcflags "-trimpath=${S}"
	)

	ego build "${mygoargs[@]}" -o restic ./cmd/restic
}

src_test() {
	addwrite /dev/fuse
	# a number of the ./cmd/... tests fail
	# ego test -timeout 30m ./cmd/... ./internal/...
	RESTIC_TEST_FUSE=0 ego test -timeout 30m ./internal/...
}

src_install() {
	dobin restic

	newbashcomp doc/bash-completion.sh "${PN}"
	newzshcomp doc/zsh-completion.zsh _restic
	newfishcomp doc/fish-completion.fish "${PN}"

	doman doc/man/*
	dodoc doc/*.rst
}
