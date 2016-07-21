# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils user

DESCRIPTION="Postfix Sender Rewriting Scheme daemon"
SRC_URI="https://github.com/roehling/postsrsd/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/roehling/postsrsd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	cmake-utils_src_install
	newinitd "${FILESDIR}/postsrsd.init" postsrsd
	newconfd "${BUILD_DIR}/postsrsd.default" postsrsd
}
