# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 edo go-module

DESCRIPTION="A command line tool for DigitalOcean services"
HOMEPAGE="https://github.com/digitalocean/doctl"
SRC_URI="https://github.com/digitalocean/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT BSD BSD-2 ISC MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	LDFLAGS="-X github.com/digitalocean/doctl.Major=$(ver_cut 1)
		-X github.com/digitalocean/doctl.Minor=$(ver_cut 2)
		-X github.com/digitalocean/doctl.Patch=$(ver_cut 3-)
		-X github.com/digitalocean/doctl.Label=release"
	GOFLAGS="-v -x -mod=vendor" ego build -ldflags "$LDFLAGS" ./cmd/...

	local completion
	for completion in bash zsh fish ; do
		edo ./doctl completion ${completion} > doctl.${completion} \
			|| die "completion for ${completion} failed"
	done
}

src_test() {
	GOFLAGS="-v -x -mod=vendor" ego test -work ./do/... ./pkg/... .
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
