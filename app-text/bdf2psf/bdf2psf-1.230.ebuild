# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Converter to generate console fonts from BDF source fonts"
HOMEPAGE="https://packages.debian.org/sid/bdf2psf"
SRC_URI="mirror://debian/pool/main/c/console-setup/console-setup_${PV}.tar.xz"
S="${WORKDIR}/console-setup-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="dev-lang/perl"

src_compile() {
	:
}

src_install() {
	dobin Fonts/bdf2psf

	insinto /usr/share/bdf2psf
	doins -r Fonts/*.equivalents Fonts/*.set Fonts/fontsets

	doman man/bdf2psf.1
	dodoc debian/README.fontsets
}
