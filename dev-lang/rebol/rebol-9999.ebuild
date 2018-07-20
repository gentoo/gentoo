# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

MY_PR=${PVR/3_pre/}

inherit eutils git-r3

DESCRIPTION="Relative Expression-Based Object Language"
HOMEPAGE="http://rebol.com"
EGIT_REPO_URI="https://github.com/rebol/r3.git"

LICENSE="Apache-2.0"
SLOT="0"
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
