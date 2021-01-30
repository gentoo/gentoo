# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/digitalocean/${PN}.git"

inherit bash-completion-r1 git-r3 go-module

DESCRIPTION="A command line tool for DigitalOcean services"
HOMEPAGE="https://github.com/digitalocean/doctl"
SRC_URI=""

LICENSE="Apache-2.0 MIT BSD BSD-2 ISC MPL-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

src_unpack() {
	git-r3_src_unpack
}

src_compile() {
	GOFLAGS="-v -x -mod=vendor" \
		go build ./cmd/... || die "build failed"

	./doctl completion bash > doctl.bash || die "completion for bash failed"
	./doctl completion zsh > doctl.zsh || die "completion for sh failed"
	./doctl completion fish > doctl.fish || die "completion for fish failed"
}

src_test() {
	GOFLAGS="-v -x -mod=vendor" \
		go test -work ./do/... ./pkg/... . || die "test failed"
}

src_install() {
	einstalldocs
	dobin doctl

	newbashcomp doctl.bash doctl
	insinto /usr/share/zsh/site-functions
	newins doctl.zsh _doctl
	insinto /usr/share/fish/completion
	newins doctl.fish doctl
}
