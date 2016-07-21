# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

DESCRIPTION="Utility to change the Mesa OpenGL driver being used"
HOMEPAGE="https://www.gentoo.org/"

SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND=">=app-admin/eselect-1.2.4
	>=app-shells/bash-4"

src_install() {
	insinto /usr/share/eselect/modules
	doins mesa.eselect || die
}

pkg_postinst() {
	if has_version ">=media-libs/mesa-7.9" && \
		! [ -f "${EROOT}"/usr/share/mesa/eselect-mesa.conf ]; then
		eerror "Rebuild media-libs/mesa for ${PN} to work."
	fi
}
