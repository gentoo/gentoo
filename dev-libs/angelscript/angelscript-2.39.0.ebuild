# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{13..15} )
inherit flag-o-matic meson python-any-r1

DESCRIPTION="A flexible, cross-platform scripting library"
HOMEPAGE="https://www.angelcode.com/angelscript/"
SRC_URI="https://www.angelcode.com/angelscript/sdk/files/angelscript_${PV}.zip"

S="${WORKDIR}/sdk"
EMESON_SOURCE="${S}/${PN}/projects/meson"

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="doc"

BDEPEND="
	${PYTHON_DEPS}
	app-arch/unzip
"

src_configure() {
	# The static Makefile adds this flag. There are lots of warnings without it.
	append-cxxflags -fno-strict-aliasing
	meson_src_configure
}

src_install() {
	meson_src_install
	if use doc; then
		docinto html
		dodoc -r docs/*
	fi
}
