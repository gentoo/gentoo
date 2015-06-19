# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/mock/mock-1.0.3.ebuild,v 1.3 2012/06/07 21:35:09 zmedico Exp $

EAPI="2"

inherit eutils user

DESCRIPTION="create chroots and build packages in them for Fedora and RedHat"
HOMEPAGE="http://fedoraproject.org/wiki/Projects/Mock"
SRC_URI="https://fedorahosted.org/mock/attachment/wiki/MockTarballs/mock-${PV}.tar.gz?format=raw -> mock-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/yum
	dev-python/decoratortools"

src_install() {
	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	enewgroup mock
}
