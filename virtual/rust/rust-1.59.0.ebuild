# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Rust language compiler"

SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv x86"
IUSE="rustfmt"

RDEPEND="|| (
	~dev-lang/rust-${PV}[rustfmt?]
	~dev-lang/rust-bin-${PV}[rustfmt?]
)"
