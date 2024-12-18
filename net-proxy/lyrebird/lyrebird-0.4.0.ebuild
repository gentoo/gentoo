# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="An obfuscating proxy supporting Tor's pluggable transport protocol obfs4"
HOMEPAGE="https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/lyrebird"
SRC_URI="https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/${PN}/-/archive/${P}/${PN}-${P}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"
S="${WORKDIR}"/${PN}-${P}

LICENSE="BSD CC0-1.0 BZIP2 GPL-3+ MIT public-domain"
SLOT="0"
KEYWORDS="amd64 arm ~riscv x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-obfs4proxy )"
BDEPEND=">=dev-lang/go-1.21"

DOCS=( README.md ChangeLog doc/obfs4-spec.txt )

src_compile() {
	ego build ./cmd/${PN}
}

src_install() {
	dobin ${PN}
	doman doc/${PN}.1
}

pkg_postinst() {
	if [[ ! -z "${REPLACING_VERSIONS}" ]]; then
		local oldver
		for oldver in ${REPLACING_VERSIONS}; do
			if ver_test "${oldver}" -lt 0.1.0; then
				ewarn "Since version 0.1.0 the proxy executable is called '${PN}' rather than 'obfs4proxy'."
				ewarn "Please update your Tor configuration accordingly."
				ewarn
				break
			fi
		done
	fi
}
