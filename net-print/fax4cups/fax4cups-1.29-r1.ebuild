# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fax backend for CUPS"
HOMEPAGE="http://vigna.dsi.unimi.it/fax4CUPS/"
SRC_URI="http://vigna.dsi.unimi.it/fax4CUPS/fax4CUPS-${PV}.tar.gz"
S="${WORKDIR}/fax4CUPS-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+hylafax mgetty-fax efax"
REQUIRED_USE="|| ( hylafax mgetty-fax efax )"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}
	|| (
		hylafax? ( net-misc/hylafaxplus )
		efax? ( net-misc/efax )
		mgetty-fax? ( net-dialup/mgetty )
	)
	app-admin/sudo
"
BDEPEND="net-print/cups"

src_install() {
	doman fax4CUPS.1

	exeinto $(cups-config --serverbin || die)/backend
	insinto /usr/share/cups/model

	local i
	for i in hylafax efax mgetty-fax; do
		if use ${i}; then
			# Backend
			doexe ${i}
			# PPD
			doins ${i}.ppd
		fi
	done
}

pkg_postinst() {
	elog "Please execute '${EROOT}/etc/init.d/cups restart'"
	elog "to get the *.ppd files working properly"
}
