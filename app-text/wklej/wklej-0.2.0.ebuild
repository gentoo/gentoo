# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wklej/wklej-0.2.0.ebuild,v 1.3 2011/02/20 16:16:34 xarthisius Exp $

EAPI=3

PYTHON_DEPEND="*:2.6"
inherit eutils python

DESCRIPTION="A wklej.org submitter"
HOMEPAGE="http://wklej.org"
SRC_URI="http://wklej.org/m/apps/wklej-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE="+vim"

DEPEND=""
RDEPEND="vim? ( app-editors/vim[python] )"

S=${WORKDIR}

src_install() {
	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins ${PN}.vim || die "Failed to install vim plugin"
	fi

	dobin ${PN} || die "Failed to install ${PN} script"
	dodoc README wklejrc || die "Failed to install readme"
}

pkg_postinst() {
	elog "There are lots of changes in ${PV} version"
	elog "Check out the documents in /usr/share/doc/${PF}"
}
