# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mount-boot

DESCRIPTION="Tools for using the ESRT and UpdateCapsule() to apply firmware updates"
HOMEPAGE="https://github.com/rhinstaller/fwupdate"
SRC_URI="https://github.com/rhinstaller/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/popt
	sys-libs/efivar
	>=sys-libs/libsmbios-2.3.2
"
DEPEND="
	${RDEPEND}
	sys-boot/gnu-efi
"

do_make() {
	emake \
		EFIDIR="gentoo" \
		GNUEFIDIR="/usr/$(get_libdir)" \
		"${@}"
}

src_compile() {
	do_make
}

src_install() {
	do_make DESTDIR="${D}" install
}
