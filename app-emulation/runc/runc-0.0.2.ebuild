# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/runc/runc-0.0.2.ebuild,v 1.2 2015/07/23 20:29:32 cardoe Exp $

EAPI=5

DESCRIPTION="runc container cli tools"
HOMEPAGE="http://runc.io"

GITHUB_URI="github.com/opencontainers/runc"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://${GITHUB_URI}.git"
	inherit git-r3
else
	SRC_URI="https://${GITHUB_URI}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

inherit multilib

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.4:="
RDEPEND=""

src_prepare() {
	epatch_user
}

src_compile() {
	# Taken from app-emulation/docker-1.7.0-r1
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="-L${ROOT}/usr/$(get_libdir)"

	# Setup GOPATH so things build
	rm -rf .gopath
	mkdir -p .gopath/src/"$(dirname "${GITHUB_URI}")"
	ln -sf ../../../.. .gopath/src/"${GITHUB_URI}"
	export GOPATH="${PWD}/.gopath:${PWD}/vendor"

	make
}

src_install() {
	dobin runc
}
