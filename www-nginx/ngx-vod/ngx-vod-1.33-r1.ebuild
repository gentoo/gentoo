# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-vod-module"

inherit ffmpeg-compat flag-o-matic nginx-module toolchain-funcs

DESCRIPTION="NGINX-based MP4 Repackager"
HOMEPAGE="https://github.com/kaltura/nginx-vod-module"
SRC_URI="
	https://github.com/kaltura/nginx-vod-module/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Uses custom Python-based testing framework.
RESTRICT="test"

BDEPEND="virtual/pkgconfig"
DEPEND="
	dev-libs/openssl:=
	dev-libs/libxml2:=
	media-video/ffmpeg-compat:8=
	virtual/zlib:=
	virtual/libiconv
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.33-fix-clock-gettime-config-check.patch"
	"${FILESDIR}/${PN}-1.33-use-prototyped-declaration.patch"
	"${FILESDIR}/${PN}-1.33-fix-ffmpeg-7-avcodec_close.patch" # Bug 965416
)

src_prepare() {
	nginx-module_src_prepare

	# TODO: fix with >=ffmpeg-9 then drop compat (bug #980848),
	# note that can cleanup the virtual/pkgconfig bdep if dropped
	ffmpeg_compat_setup 8
	append-cflags $($(tc-getPKG_CONFIG) --cflags libavcodec || die)
	local ffldflags=$($(tc-getPKG_CONFIG) --libs-only-{L,other} libavcodec || die)
	ngx_mod_append_ldflags ${ffldflags}
	# hack: ngx_mod_append_ldflags does not (currently) add flags for
	# ./configure and, if non-compat ffmpeg is not installed *too*, it
	# will fail to find it without and disable support altogether
	sed -i "1i\\NGX_TEST_LD_OPT=\"\$NGX_TEST_LD_OPT ${ffldflags}\"" config || die
}
