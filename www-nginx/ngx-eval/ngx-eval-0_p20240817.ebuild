# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_COMMIT="13425e897c19f4f4436c5ca4414dddd37fc65190"
MY_P="nginx-eval-module-${MY_COMMIT}"
NGINX_MOD_S="${WORKDIR}/${MY_P}"

inherit nginx-module

DESCRIPTION="An NGINX module that stores subrequest response bodies into variables"
HOMEPAGE="https://github.com/openresty/nginx-eval-module"
SRC_URI="
	https://github.com/openresty/nginx-eval-module/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

RESTRICT="test"
