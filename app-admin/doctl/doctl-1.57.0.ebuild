# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

DESCRIPTION="A command line tool for DigitalOcean services"
HOMEPAGE="https://github.com/digitalocean/doctl"
SRC_URI="https://github.com/digitalocean/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT BSD BSD-2 ISC MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	LDFLAGS="-X github.com/digitalocean/doctl.Major=$(ver_cut 1)
		-X github.com/digitalocean/doctl.Minor=$(ver_cut 2)
		-X github.com/digitalocean/doctl.Patch=$(ver_cut 3-)
		-X github.com/digitalocean/doctl.Label=release"
	GOFLAGS="-v -x -mod=vendor" \
		go build -ldflags "$LDFLAGS" ./cmd/... || die "build failed"

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
