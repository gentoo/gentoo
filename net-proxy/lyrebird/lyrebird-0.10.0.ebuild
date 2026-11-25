# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver go-module

DESCRIPTION="An obfuscating proxy supporting Tor's pluggable transport protocol obfs4"
HOMEPAGE="https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/lyrebird"
SRC_URI="https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/${PN}/-/archive/${PV}/${PN}-${P}.tar.bz2"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/${PV}/${P}-deps.tar.xz"
S="${WORKDIR}/${P}-59ac7e400c384773f5584dbe366516ad04a33d9f"

LICENSE="BSD CC0-1.0 BZIP2 GPL-3+ MIT public-domain"
# Dependent licenses
LICENSE+="  0BSD Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-obfs4proxy )"
BDEPEND=">=dev-lang/go-1.26.10"

DOCS=( README.md ChangeLog doc/obfs4-spec.txt )

src_compile() {
	ego build ./cmd/${PN}
}

src_install() {
	dobin ${PN}
	doman doc/${PN}.1
}

pkg_postinst() {
	if ver_replacing -lt 0.1.0; then
		ewarn "Since version 0.1.0 the proxy executable is called '${PN}' rather than 'obfs4proxy'."
		ewarn "Please update your Tor configuration accordingly."
		ewarn
	fi
}
