# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=3f0542e4e034aab417c51b2b22c94f83355dee15

DESCRIPTION="CMake module to enable sanitizers for binary targets"
HOMEPAGE="https://github.com/arsenm/sanitizers-cmake/"
SRC_URI="https://github.com/arsenm/sanitizers-cmake/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

src_install() {
	insinto /usr/share/${PN}
	doins -r cmake/*
}
