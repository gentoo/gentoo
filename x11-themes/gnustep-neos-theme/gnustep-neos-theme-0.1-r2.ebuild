# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2 vcs-clean

DESCRIPTION="GNUstep theme closely following the original NeXT look and feel"
HOMEPAGE="https://gap.nongnu.org/themes/index.html"
SRC_URI="https://download.savannah.gnu.org/releases/gap/Neos-${PV}.theme.tar.gz"
S=${WORKDIR}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="binchecks strip"

src_prepare() {
	default
	ecvs_clean
}

src_compile() { :; }

src_install() {
	egnustep_env

	#install themes
	insinto ${GNUSTEP_SYSTEM_LIBRARY}/Themes
	doins -r "${S}"/*theme
}

pkg_postinst() {
	elog "Use gnustep-apps/systempreferences to switch theme"
}
