# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-multilib

DESCRIPTION="High-performance messaging interface for distributed applications"
HOMEPAGE="http://nanomsg.org/"
SRC_URI="https://github.com/nanomsg/nanomsg/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/5.0.0"
KEYWORDS="~amd64 ~arm"
IUSE="doc static-libs"

DEPEND="doc? ( dev-ruby/asciidoctor )"
RDEPEND=""

multilib_src_configure() {
	local mycmakeargs=(
		-DNN_STATIC_LIB=$(usex static-libs ON OFF)
	)
	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DNN_ENABLE_DOC=$(usex doc ON OFF)
		)
	else
		mycmakeargs+=(
			-DNN_ENABLE_DOC=OFF
			-DNN_ENABLE_TOOLS=OFF
			-DNN_ENABLE-NANOCAT=OFF
		)
	fi
	cmake-utils_src_configure
}
