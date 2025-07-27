# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER=1.82.0
inherit cargo

DESCRIPTION="Tool to 'cargo vendor' with filtering"
HOMEPAGE="https://github.com/coreos/cargo-vendor-filterer/"
SRC_URI="
	https://github.com/coreos/cargo-vendor-filterer/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${P}-vendor.tar.xz
"

LICENSE="Apache-2.0"
LICENSE+=" MIT Unicode-DFS-2016" # crates
SLOT="0"
KEYWORDS="~amd64"
# vendors itself for tests, messy when already vendoring+offline
RESTRICT="test"

QA_FLAGS_IGNORED="usr/bin/${PN}"
