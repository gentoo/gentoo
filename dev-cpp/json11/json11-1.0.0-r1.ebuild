# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A tiny JSON library for C++11"
HOMEPAGE="https://github.com/dropbox/json11"
SRC_URI="https://github.com/dropbox/json11/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-fix-multiarch-install.patch
	"${FILESDIR}"/${PN}-1.0.0-json11.pc-do-not-state-the-defaults.patch
	"${FILESDIR}"/${PN}-1.0.0-include-cstdint.patch
)
