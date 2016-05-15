# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF="1"
inherit eutils autotools-utils

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/sahlberg/libiscsi.git"
	KEYWORDS="~hppa ~ppc64"
else
	SRC_URI="https://github.com/sahlberg/libiscsi/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~hppa ~ppc64 x86"
fi

DESCRIPTION="iscsi client library and utilities"
HOMEPAGE="https://github.com/sahlberg/libiscsi"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/ld_iscsi.so"

myeconfargs=( "--disable-werror" )

src_prepare() {
	epatch "${FILESDIR}"/${P}-00*.patch

	epatch_user

	autotools-utils_src_prepare
}
