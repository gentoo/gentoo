# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo git-r3 go-module shell-completion

DESCRIPTION="A command line tool for DigitalOcean services"
HOMEPAGE="https://github.com/digitalocean/doctl"
EGIT_REPO_URI="https://github.com/digitalocean/${PN}.git"

LICENSE="Apache-2.0 MIT BSD BSD-2 ISC MPL-2.0"
SLOT="0"

src_unpack() {
	git-r3_src_unpack
}

src_compile() {
	LDFLAGS="-X github.com/digitalocean/doctl.Build=$(git rev-parse --short HEAD)
		-X github.com/digitalocean/doctl.Label=dev"
	GOFLAGS="-v -x -mod=vendor" ego build -ldflags "$LDFLAGS" ./cmd/...

	local completion
	for completion in bash zsh fish ; do
		edo ./doctl completion ${completion} > doctl.${completion} \
			|| die "completion for ${completion} failed"
	done
}

src_test() {
	GOFLAGS="-v -x -mod=vendor" ego test -work ./commands/... ./do/... \
		./pkg/... ./internal/... .
}

src_install() {
	einstalldocs
	dobin doctl

	newbashcomp doctl.bash doctl
	newfishcomp doctl.fish doctl
	newzshcomp doctl.zsh _doctl
}
