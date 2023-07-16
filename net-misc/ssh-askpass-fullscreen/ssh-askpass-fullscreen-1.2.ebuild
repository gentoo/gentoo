# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A small SSH Askpass replacement written with GTK2"
HOMEPAGE="https://github.com/atj/ssh-askpass-fullscreen"
SRC_URI="https://github.com/atj/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ~riscv sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.10.0:2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# automake-1.13 fix, bug #468764
	sed -i -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' configure.ac || die "sed #1 failed"

	eapply_user
	eautoreconf
}

src_install() {
	default

	doman "${FILESDIR}"/ssh-askpass-fullscreen.1

	# Automatically display the passphrase dialog - see bug #437764
	echo "SSH_ASKPASS='${EPREFIX}/usr/bin/ssh-askpass-fullscreen'" >> "${T}/99ssh_askpass" \
		|| die "envd file creation failed"
	doenvd "${T}"/99ssh_askpass
}
