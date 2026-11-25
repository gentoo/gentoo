# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="A friendly programming language from the future"
HOMEPAGE="https://unison-lang.org/
	https://github.com/unisonweb/unison/"

SRC_BASE="https://github.com/unisonweb/unison/releases/download/release%2F${PV}"
SRC_URI="
	amd64? ( ${SRC_BASE}/ucm-linux-x64.tar.gz   -> ${P}.amd64.linux.bin.tar.gz )
	arm64? ( ${SRC_BASE}/ucm-linux-arm64.tar.gz -> ${P}.arm64.linux.bin.tar.gz )
"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/gmp
	virtual/zlib:=
"

QA_PREBUILT="*"

src_install() {
	local app_home="/usr/share/${P}"

	insinto "/usr/share/${P}"
	cp -r "${WORKDIR}"/* "${ED}/${app_home}"
	dosym -r "${app_home}/ucm" /usr/bin/ucm
	dosym -r "${app_home}/ucm" /usr/bin/unisonlang
}
