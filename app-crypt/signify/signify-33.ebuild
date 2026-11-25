# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Cryptographically sign and verify files"
HOMEPAGE="
	https://www.openbsd.org/
	https://github.com/aperezdc/signify/
"
SRC_URI="
	https://github.com/aperezdc/signify/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

DEPEND="
	>=dev-libs/libbsd-0.7
"
RDEPEND="
	${DEPEND}
	!net-mail/signify
"
