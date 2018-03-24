# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3

DESCRIPTION="Simple ASDF-BINARY-LOCATIONS configuration for Gentoo Common Lisp ports"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Common_Lisp/Guide"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

S=${WORKDIR}

DEPEND="dev-lisp/asdf-binary-locations"
RDEPEND="${DEPEND}"

src_install() {
	insinto /etc
	doins "${FILESDIR}"/gentoo-init.lisp
}
