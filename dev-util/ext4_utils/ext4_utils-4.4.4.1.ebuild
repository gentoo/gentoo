# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ext4_utils/ext4_utils-4.4.4.1.ebuild,v 1.3 2014/07/30 16:36:12 jauhien Exp $

EAPI=5

DESCRIPTION="Tools for Android images"
HOMEPAGE="https://android.googlesource.com/platform/system/extras"
SRC_URI="http://dev.gentoo.org/~jauhien/distfiles/${P}.tar.gz
	http://dev.gentoo.org/~jauhien/distfiles/libselinux-android-${PV}.tar.gz
	http://dev.gentoo.org/~jauhien/distfiles/android-system-core-include-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"

DEPEND="dev-util/libsparse"
RDEPEND="${DEPEND}"

src_prepare() {
	cp "${FILESDIR}/Makefile" "${S}"
}
