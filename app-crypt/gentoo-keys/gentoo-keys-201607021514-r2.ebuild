# Copyright 2014-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="A OpenPGP/GPG keyring of official Gentoo release media GPG keys"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Gentoo-keys"
SRC_URI="https://dev.gentoo.org/~dolsen/releases/keyrings/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc64 ~ppc ~sparc ~x86 ~arm64 ~x86-fbsd ~amd64-fbsd ~m68k ~mips ~s390 ~sh"

S="${WORKDIR}"

src_install() {
	insinto /var/lib/gentoo/gkeys/keyrings
	doins -r gentoo
}
