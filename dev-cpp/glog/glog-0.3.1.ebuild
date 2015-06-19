# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/glog/glog-0.3.1.ebuild,v 1.3 2013/01/10 20:39:56 vapier Exp $

EAPI="4"
inherit eutils

DESCRIPTION="Google's C++ logging library"
HOMEPAGE="http://code.google.com/p/google-glog/"
SRC_URI="http://google-glog.googlecode.com/files/${P}-1.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gflags static-libs test"

RDEPEND="gflags? ( dev-cpp/gflags )"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gmock
		dev-cpp/gtest
	)"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.3.2-avoid-inline-asm.patch
}

src_configure() {
	export ac_cv_lib_gflags_main=$(usex gflags)
	use test || export ac_cv_prog_GTEST_CONFIG=no
	econf $(use_enable static-libs static)
}
