# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Header-only C++ library for JSON Schema validation"
HOMEPAGE="https://github.com/tristanpenman/valijson"
SRC_URI="https://github.com/tristanpenman/valijson/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PV}-fix-macro-typos.patch
)

src_install() {
	# there is no target for installing headers, so do it manually
	doheader -r include/*
}
