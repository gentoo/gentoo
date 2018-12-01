# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="A set of libraries for userspace access to RTAS on the PowerPC platform(s)"
HOMEPAGE="https://github.com/ibm-power-utilities/librtas"
SRC_URI="https://github.com/ibm-power-utilities/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="ppc ppc64"
IUSE=""

DOCS="README"

src_prepare() {
	eapply_user

	eautoreconf
}
