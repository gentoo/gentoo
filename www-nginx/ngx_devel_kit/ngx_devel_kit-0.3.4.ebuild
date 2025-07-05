# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic nginx-module

DESCRIPTION="An NGINX module that adds generic tools for third-party modules"
HOMEPAGE="https://github.com/vision5/ngx_devel_kit"
SRC_URI="
	https://github.com/vision5/ngx_devel_kit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_configure() {
	# ngx_devel_kit (NDK) is designed in a modular way. As such, only the
	# required modules are built based if the corresponding preprocessor macros
	# are defined.
	#
	# Since we do not want to deal with a dependency hell (other NGINX plugins
	# depend on dfferent NDK's modules) and a bunch of USE flag toggles, NDK is
	# compiled with all its modules. Fortunately, even with all the modules
	# built-in, the resulting binary is really small, so the size is not an
	# issue.
	#
	# For details, have a look at 'objs/ndk_config.c' in NDK's source tree and
	# the 'modular' section in 'README.md'.
	append-cflags -DNDK_ALL
	nginx-module_src_configure
}

src_install() {
	nginx-module_src_install

	pushd "${NGINX_MOD_S}" >/dev/null || die "pushd failed"

	# Install ngx_devel_kit's headers for use by other modules.
	insinto /usr/include/nginx/modules
	find objs src -maxdepth 1 -type f -name '*.h' -print0 | xargs -0 doins
	assert "find failed"

	popd >/dev/null || die "popd failed"
}
