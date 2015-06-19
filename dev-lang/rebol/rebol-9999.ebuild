# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/rebol/rebol-9999.ebuild,v 1.2 2015/06/19 11:08:38 ulm Exp $

EAPI=4
DESCRIPTION="Relative Expression-Based Object Language"
HOMEPAGE="http://rebol.com"

MY_PR=${PVR/3_pre/}
EGIT_REPO_URI="git://github.com/rebol/r3.git"

inherit eutils git-2

LICENSE="Apache-2.0"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
# live ebuild
KEYWORDS=""
IUSE=""

# usual bootstrap problems
DEPEND="|| ( dev-lang/rebol dev-lang/rebol-bin )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/$(STRIP) r3//' make/makefile || die
}

src_compile() {
	cd make
	# silly build system. Prefer prebuilt for now
	[[ -f /opt/rebol/r3 ]] && cp /opt/rebol/r3 ./r3-make || cp /usr/bin/r3 ./r3-make
	make prep || die
	make || die
}

src_install() {
	mkdir -p "${D}/usr/bin"
	cp "${S}/make/r3" "${D}/usr/bin/r3" || die
}
