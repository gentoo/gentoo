# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="C-language implementation of Javascript Object Signing and Encryption"
HOMEPAGE="https://github.com/latchset/jose"
SRC_URI="https://github.com/latchset/jose/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/jansson
	dev-libs/openssl:=
	sys-libs/zlib
"
BDEPEND="
	virtual/pkgconfig
	app-text/asciidoc
"
