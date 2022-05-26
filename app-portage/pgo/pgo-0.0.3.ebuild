# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/arzano/pgo"
else
	SRC_URI="https://github.com/arzano/pgo/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi

DESCRIPTION="A command line interface for packages.gentoo.org"
HOMEPAGE="https://github.com/arzano/pgo"
LICENSE="BSD-2"
SLOT="0"

src_compile() {
	env GOBIN="${S}/bin" go build -mod=vendor || die "compile failed"
}

src_install() {
	dobin pgo
}
