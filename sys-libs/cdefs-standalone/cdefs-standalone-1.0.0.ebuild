# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Compatibility library for musl"
HOMEPAGE="https://github.com/void-linux/void-packages/tree/master/srcpkgs/musl-legacy-compat"

LICENSE="|| ( BSD-2 BSD )"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"

src_install() {
	doheader -r "${FILESDIR}/sys/${PN%%-*}.h"
}
