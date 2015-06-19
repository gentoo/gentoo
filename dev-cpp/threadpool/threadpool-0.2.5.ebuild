# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/threadpool/threadpool-0.2.5.ebuild,v 1.2 2012/10/07 04:13:03 mr_bones_ Exp $

EAPI=4

inherit base

DESCRIPTION="A cross-platform C++ thread pool library (built on top of Boost)"
HOMEPAGE="http://threadpool.sourceforge.net/"
MY_PV=${PV//./_}
MY_P=${PN}-${MY_PV}
SRC_URI_BASE="mirror://sourceforge/threadpool/threadpool/${PV}%20%28Stable%29"
SRC_URI="${SRC_URI_BASE}/${MY_P}-src.zip
		doc? ( ${SRC_URI_BASE}/${MY_P}-doc.zip )"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="dev-libs/boost"

S="${WORKDIR}/${MY_P}-src/${PN}"

PATCHES=( "${FILESDIR}/${P}-memleak.patch" )

src_prepare() {
	base_src_prepare
}

src_compile() {
	# Do nothing
	# The makefile just builds the documentation again
	# Not even any install targets
	:
}

src_install() {
	insinto /usr/include/
	doins -r boost
	dodoc README TODO CHANGE_LOG
	if use doc; then
		dohtml -r "${WORKDIR}"/"${MY_P}"-doc/
	fi
}
