# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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

DOCS=( README TODO CHANGE_LOG )
PATCHES=( "${FILESDIR}/${P}-memleak.patch" )

src_compile() {
	# Do nothing
	# The makefile just builds the documentation again
	# Not even any install targets
	return
}

src_install() {
	doheader -r boost

	use doc && HTML_DOCS+=( "${WORKDIR}"/"${MY_P}"-doc/. )
	einstalldocs
}
