# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Integrates Pidgin (and libpurple) with the system keyring"
HOMEPAGE="https://github.com/aebrahim/pidgin-gnome-keyring"
SRC_URI="https://github.com/aebrahim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-crypt/libsecret
	net-im/pidgin"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-pkgconfig_dirs.patch"
)

src_prepare() {
	default

	# This file is used by the upstream Makefile yet as of 2.0 is still missing
	# from release tarballs.
	echo "${PV}" > VERSION || die "Failed to recreate version file"
}
