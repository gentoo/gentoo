# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nginx-module

DESCRIPTION="Fancy indexes module for the NGINX web server"
HOMEPAGE="https://github.com/aperezdc/ngx-fancyindex"
SRC_URI="
	https://github.com/aperezdc/ngx-fancyindex/releases/download/v${PV}/${P}.tar.xz
"

LICENSE="BSD-2"
SLOT="0"

# Uses custom bash-based testing framework.
RESTRICT="test"
