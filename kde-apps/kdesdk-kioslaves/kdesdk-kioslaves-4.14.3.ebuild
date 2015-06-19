# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kdesdk-kioslaves/kdesdk-kioslaves-4.14.3.ebuild,v 1.1 2015/06/04 18:44:37 kensington Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="kioslaves from kdesdk package"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug subversion"
KMNAME="kdesdk-kioslaves"

DEPEND="
	subversion? (
		dev-libs/apr
		dev-vcs/subversion
	)
"
RDEPEND="${DEPEND}
	subversion? ( !>=dev-vcs/kdesvn-1.5.2:4 )
"

src_configure() {
	local mycmakeargs=(
		-DAPRCONFIG_EXECUTABLE="${EPREFIX}"/usr/bin/apr-1-config
		$(cmake-utils_use_with subversion SVN)
	)

	kde4-base_src_configure
}
