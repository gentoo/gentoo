# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Package manager for Rust"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

CARGO_DEPEND_VERSION="0.$(($(ver_cut 2) + 1)).0"

RDEPEND="|| (
			=dev-lang/rust-${PV}*[cargo]
			=dev-lang/rust-bin-${PV}*[cargo]
			=dev-util/cargo-${CARGO_DEPEND_VERSION}*
		)"
