# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Rust Language Tag and Release Signing Key"
HOMEPAGE="https://forge.rust-lang.org/infra/other-installation-methods.html"
SRC_URI="https://static.rust-lang.org/rust-key.gpg.ascii"
# https://keybase.io/rust/pgp_keys.asc?fingerprint=108f66205eaeb0aaa8dd5e1c85ab96e6fa1be5fe
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - rust.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}
