# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Emulates scrollwheel, right- & left-click for one-button mice/touchpads"
HOMEPAGE="http://geekounet.org/powerbook/"
SRC_URI="mirror://gentoo/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-* ~ppc"

PATCHES=(
	"${FILESDIR}"/${PN}-0.13-fix.patch
	"${FILESDIR}"/${PN}-0.15-build.patch
	"${FILESDIR}"/${PN}-0.15-openrc.patch
)

src_compile() {
	edo $(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} ${PN}.c
}

src_install() {
	dosbin mouseemu
	einstalldocs

	newinitd mouseemu.init.gentoo mouseemu
	insinto /etc
	doins mouseemu.conf
}

pkg_postinst() {
	einfo "For mouseemu to work you need uinput support in your kernel:"
	einfo "        CONFIG_INPUT_UINPUT=y"
	einfo "(Device Drivers->Input device support->Misc->User level driver support)"
	einfo "Don't forget to add mouseemu to your default runlevel:"
	einfo "        rc-update add mouseemu default"
	einfo "Configuration is in /etc/mouseemu.conf."
}
