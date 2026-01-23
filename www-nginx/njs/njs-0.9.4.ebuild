# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NGINX_MOD_CONFIG_DIR="nginx"

inherit edo nginx-module toolchain-funcs

DESCRIPTION="A subset of JavaScript language to use in NGINX"
HOMEPAGE="https://github.com/nginx/njs https://nginx.org/en/docs/njs/"
SRC_URI="
	https://github.com/nginx/njs/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64"

IUSE="tools +ssl +xml +zlib"

RDEPEND="
	dev-libs/quickjs-ng:=
	tools? (
		dev-libs/libpcre2:=
		sys-libs/readline:=
	)
	ssl? ( dev-libs/openssl:= )
	xml? (
		dev-libs/libxml2:=
		dev-libs/libxslt:=
	)
	zlib? ( virtual/zlib:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# Note: drop on the next upgrade, has been merged upstream as PR 989.
	"${FILESDIR}/${PN}-0.9.4-support-quickjs-ng.patch"

	"${FILESDIR}/${PN}-0.9.4-do-not-add-opt-debug-cflags.patch"
)

src_configure() {
	## The core part, i.e. libnjs and libqjs.
	local myargs=(
		--build-dir=build
		--cc="$(tc-getCC)"
		--ld-opt="${LDFLAGS}"
		--ar="$(tc-getAR)"
	)

	local nocliargs=(
		--no-openssl
		--no-libxml2
		--no-zlib
	)

	if use tools; then
		use !ssl    && myargs+=( '--no-openssl' )
		use !xml    && myargs+=( '--no-libxml2' )
		use !zlib   && myargs+=( '--no-zlib'    )
	else
		myargs+=( "${nocliargs[@]}" )
	fi

	pushd "${NGINX_MOD_S}" >/dev/null || die "pushd failed"
	edo ./configure "${myargs[@]}"
	popd >/dev/null || die "popd failed"

	## The NGINX module part.
	# Build the stream module unconditionally.
	sed -i "s/\\\$STREAM/YES/" "${NGINX_MOD_S}/${NGINX_MOD_CONFIG_DIR}/config" ||
		die "sed failed"

	# Export PKG_CONFIG for pkg-config-based QuickJS-NG detection.
	tc-export PKG_CONFIG

	if use ssl; then
		# Because NGINX build system refuses to link OPENSSL and ZLIB normally
		# like other libraries.
		ngx_mod_link_lib openssl
	else
		local -x NJS_OPENSSL=NO
	fi

	if use zlib; then
		# Ditto.
		ngx_mod_link_lib zlib
	else
		local -x NJS_ZLIB=NO
	fi

	use !xml && local -x NJS_LIBXSLT=NO

	nginx-module_src_configure
}

src_compile() {
	# Build the core first.
	if use tools; then
		emake -C "${NGINX_MOD_S}"
	else
		emake -C "${NGINX_MOD_S}" libnjs libqjs
	fi

	nginx-module_src_compile
}

src_install() {
	use tools && dobin "${NGINX_MOD_S}"/build/njs

	nginx-module_src_install
}
