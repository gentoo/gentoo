# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="script to package go dependencies"
HOMEPAGE=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"

src_install() {
	newbin "${FILESDIR}/go-dep-tarball-0" go-dep-tarball
}
