# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NGX_BROTLI_P="ngx-brotli-a71f9312c2deb28875acc7bacfdd5695a111aa53"

MY_PN="${PN//-/_}"
inherit nginx-module

DESCRIPTION="NGINX module for Brotli compression"
HOMEPAGE="https://github.com/google/ngx_brotli"
SRC_URI="
	https://github.com/google/ngx_brotli/archive/${NGX_BROTLI_P#ngx-brotli-}.tar.gz -> ${NGX_BROTLI_P}.tar.gz
"

S="${WORKDIR}/${MY_PN}-${NGX_BROTLI_P#ngx-brotli-}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64"

BDEPEND="virtual/pkgconfig"
DEPEND="app-arch/brotli:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0_rc_p20231109-use-system-brotli.patch"
)
