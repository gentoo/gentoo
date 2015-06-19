# Copyright 2014-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gentoo-keys/gentoo-keys-201501052117.ebuild,v 1.1 2015/01/05 23:29:39 dolsen Exp $

EAPI="5"

DESCRIPTION="A Openpgp/gpg keyring of official Gentoo release media gpg keys"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Gentoo-keys"
SRC_URI="http://dev.gentoo.org/~dolsen/releases/keyrings/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="alpha amd64 arm hppa ia64 ppc64 ppc sparc x86 ~arm64 ~x86-fbsd ~amd64-fbsd ~m68k ~mips ~s390 ~sh"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_prepare(){ true; }

src_install(){
	insinto /var/lib/gentoo/gkeys/keyrings
	doins -r gentoo
}
