# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

# update on every bump
GIT_COMMIT=8514bc42ef2c15a0ff27782a22b3add584b0d21c/
go-mod/

DESCRIPTION="the official gitlab command line interface"
HOMEPAGE="https://gitlab.com/gitlab-org/cli"
SRC_URI="https://gitlab.com/gitlab-org/cli/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-man.tar.xz"
S="${WORKDIR}/cli-v${PV}-${GIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# tests communicate with gitlab.com and require a personal access token
RESTRICT="test"

QA_PRESTRIPPED=usr/bin/glab

src_compile() {
	emake \
		BUILD_COMMIT_SHA=${GIT_COMMIT::8} \
		GLAB_VERSION=v${PV} \
		build
	mv ../share "${T}" || die
}

src_install() {
	dobin bin/glab
	dodoc README.md
	doman "${T}"/share/man/man1/*
}
