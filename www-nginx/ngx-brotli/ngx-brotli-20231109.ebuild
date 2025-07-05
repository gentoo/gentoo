# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NGX_BROTLI_P="ngx-brotli-a71f9312c2deb28875acc7bacfdd5695a111aa53"
# A submodule.
BROTLI_P="brotli-ed738e842d2fbdf2d6459e39267a633c4a9b2f5d"

MY_PN="${PN//-/_}"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${NGX_BROTLI_P#ngx-brotli-}"
inherit nginx-module

DESCRIPTION="NGINX module for Brotli compression"
HOMEPAGE="https://github.com/google/ngx_brotli"
SRC_URI="
	https://github.com/google/ngx_brotli/archive/${NGX_BROTLI_P#ngx-brotli-}.tar.gz -> ${NGX_BROTLI_P}.tar.gz
	https://github.com/google/brotli/archive/${BROTLI_P#brotli-}.tar.gz -> ${BROTLI_P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_unpack() {
	nginx-module_src_unpack

	# Move the submodule to its place.
	rmdir "${NGINX_MOD_S}/deps/brotli" || die "rmdir failed"
	mv "./${BROTLI_P}" "${NGINX_MOD_S}/deps/brotli" || die "mv failed"
}
