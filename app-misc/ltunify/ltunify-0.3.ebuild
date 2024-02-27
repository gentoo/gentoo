# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev toolchain-funcs

DESCRIPTION="Tool for working with Logitech Unifying receivers and devices"
HOMEPAGE="https://lekensteyn.nl/logitech-unifying.html https://git.lekensteyn.nl/ltunify/"
SRC_URI="https://git.lekensteyn.nl/${PN}/snapshot/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=(
	NEWS
	README.txt
)

PATCHES=(
	"${FILESDIR}/ltunify-0.3-compiler-warning.patch"
	"${FILESDIR}/ltunify-0.3-ldflags.patch"
)

src_configure() {
	tc-export CC
}

src_compile() {
	emake PACKAGE_VERSION=${PV} ${PN}
}

src_install() {
	dobin ${PN}
	dodoc "${DOCS[@]}"

	udev_dorules udev/42-logitech-unify-permissions.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
