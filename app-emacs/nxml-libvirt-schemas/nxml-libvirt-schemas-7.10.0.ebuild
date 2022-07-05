# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

MY_P="libvirt-${PV}"
DESCRIPTION="Extension for nxml-mode with libvirt schemas"
HOMEPAGE="https://www.libvirt.org/"
SRC_URI="https://libvirt.org/sources/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P%-rc*}/docs/schemas"

# This is the license of the package, but the schema files are
# provided without license, maybe it's bad.
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Yes this requires Java, but I'd rather not repackage this, if you
# know something better in C, I'll be glad to use that.
BDEPEND="app-text/trang"

SITEFILE="60${PN}-gentoo.el"

src_compile() {
	emake -f "${FILESDIR}"/Makefile-trang
}

src_install() {
	insinto "${SITEETC}/${PN}"
	doins "${FILESDIR}"/schemas.xml *.rnc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
