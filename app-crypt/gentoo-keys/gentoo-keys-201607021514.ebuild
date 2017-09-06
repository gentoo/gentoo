# Copyright 2014-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="A Openpgp/gpg keyring of official Gentoo release media gpg keys"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Gentoo-keys"
SRC_URI="https://dev.gentoo.org/~dolsen/releases/keyrings/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_prepare(){ true; }

src_install(){
	insinto /var/lib/gentoo/gkeys/keyrings
	doins -r gentoo
}
