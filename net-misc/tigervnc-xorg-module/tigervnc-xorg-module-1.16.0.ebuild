# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XSERVER_VERSION="21.1.15"

DESCRIPTION="Metapackage for the xorg module provided by tigervnc"
HOMEPAGE="https://tigervnc.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	~net-misc/tigervnc-${PV}[server]
	=x11-base/xorg-server-${XSERVER_VERSION%.*}*
"
