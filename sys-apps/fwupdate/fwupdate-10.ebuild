# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mount-boot toolchain-funcs

DESCRIPTION="Tools for using the ESRT and UpdateCapsule() to apply firmware updates"
HOMEPAGE="https://github.com/rhinstaller/fwupdate"
SRC_URI="https://github.com/rhinstaller/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/popt
	>=sys-libs/efivar-32-r1
	>=sys-libs/libsmbios-2.3.2
"
DEPEND="
	${RDEPEND}
	sys-boot/gnu-efi
"

do_make() {
	emake \
		CC="$(tc-getCC)" \
		EFIDIR="gentoo" \
		GNUEFIDIR="/usr/$(get_libdir)" \
		"${@}"
}

src_prepare() {
	default

	# Remove -Werror
	sed 's@ -Werror\([[:space:]]\|\n\)@\1@' -i linux/Makefile || die
}

src_compile() {
	do_make
}

src_install() {
	do_make DESTDIR="${D}" install
}
