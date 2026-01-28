# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="XApp Symbolic Icons"
HOMEPAGE="https://github.com/xapp-project/xapp-symbolic-icons/"

SRC_URI="https://github.com/xapp-project/xapp-symbolic-icons/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/xapp-symbolic-icons-${PV}"
LICENSE="CC0-1.0 CC-BY-SA-4.0 LGPL-3 MIT"
SLOT="0"

KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
