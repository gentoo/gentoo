# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot bash-completion-r1

DESCRIPTION="A backup program that is fast, efficient and secure"
HOMEPAGE="https://restic.github.io/"
SRC_URI="https://github.com/restic/restic/archive/v${PV}.tar.gz -> ${P}.tar.gz"
EGO_PN="github.com/restic/restic"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

DEPEND="
	dev-lang/go
	test? ( sys-fs/fuse:0 )"

RDEPEND="sys-fs/fuse:0"

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_compile() {
	local mygoargs=(
		-v
		-work
		-x
		-tags release
		-ldflags "-s -w -X main.version=${PV}"
		-asmflags "-trimpath=${S}"
		-gcflags "-trimpath=${S}"
		-o restic ${EGO_PN}/cmd/restic
	)

	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go build "${mygoargs[@]}" || die
}

src_test() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go test -timeout 30m -v -work -x ${EGO_PN}/cmd/... ${EGO_PN}/internal/... || die
}

src_install() {
	dobin restic

	newbashcomp doc/bash-completion.sh "${PN}"

	insinto /usr/share/zsh/site-functions
	newins doc/zsh-completion.zsh _restic

	doman doc/man/*
	dodoc doc/*.rst
}
