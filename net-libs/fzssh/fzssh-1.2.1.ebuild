# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson
DESCRIPTION="A SSH/SFTP library based on libfilezilla"
HOMEPAGE="https://fzssh.filezilla-project.org/"
SRC_URI="https://dev.gentoo.org/~dlan/distfiles/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/12" # libfzssh.so version
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	>=dev-libs/libfilezilla-0.55.3
	>=dev-libs/gmp-6.2
	>=dev-libs/nettle-3.10
	app-crypt/argon2
	"
RDEPEND="${DEPEND}"
BDEPEND=""
