# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( FindMbedTLS )
inherit cmake

DESCRIPTION="Light-weight brokerless messaging"
HOMEPAGE="https://nng.nanomsg.org/"
SRC_URI="https://github.com/nanomsg/nng/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv"
# compat and deprecated match upstream's default choice
IUSE="+compat +deprecated doc ssl test tools"

DEPEND="ssl? ( net-libs/mbedtls:3= )"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( dev-ruby/asciidoctor )"

RESTRICT="test" # Needs network

DOCS=(README.adoc docs/RATIONALE.adoc)

PATCHES=(
	"${FILESDIR}/nng-1.11-cmake-3.patch"
)

src_configure() {
	local mycmakeargs=(
		-DNNG_ELIDE_DEPRECATED=$(usex deprecated OFF ON)
		-DNNG_ENABLE_COMPAT=$(usex compat ON OFF)
		-DNNG_ENABLE_TLS=$(usex ssl ON OFF)
		-DNNG_TESTS=$(usex test ON OFF)
		-DNNG_ENABLE_DOC=$(usex doc ON OFF)
		-DNNG_ENABLE_NNGCAT=$(usex tools ON OFF)
		-DNNG_TOOLS=$(usex tools ON OFF)
	)
	cmake_src_configure
}
