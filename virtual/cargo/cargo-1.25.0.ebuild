# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Package manager for Rust"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

BDEPEND=""
RDEPEND="|| (
			=dev-lang/rust-${PV}*[extended]
			=dev-util/cargo-0.26.0*
		)"
