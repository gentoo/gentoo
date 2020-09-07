# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
else
	KEYWORDS="amd64 ~arm ~arm64 x86"
	SRC_URI="https://github.com/rclone/rclone/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A program to sync files to and from various cloud storage providers"
HOMEPAGE="https://rclone.org/"

LICENSE="MIT"
SLOT="0"
IUSE=""

src_compile() {
		go build -mod=vendor . || die "compile failed"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README.md

	./rclone genautocomplete bash ${PN}.bash || die
	newbashcomp ${PN}.bash ${PN}

	./rclone genautocomplete zsh ${PN}.zsh || die
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}
}
