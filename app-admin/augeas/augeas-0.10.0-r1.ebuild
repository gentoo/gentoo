# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="A library for changing configuration files"
HOMEPAGE="http://augeas.net/"
SRC_URI="http://augeas.net/download/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~alpha ~amd64 hppa ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="static-libs test"

RDEPEND="
	dev-libs/libxml2
	sys-libs/readline"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=app-doc/NaturalDocs-1.40
	test? ( dev-lang/ruby )"

PATCHES=(
	"${FILESDIR}"/${P}-gets.patch
	"${FILESDIR}"/${P}-test.patch
	"${FILESDIR}"/${P}-test2.patch
	"${FILESDIR}"/${P}-libxml2-pkgconfig.patch
	)

src_prepare() {
	if [ -f /usr/share/NaturalDocs/Config/Languages.txt ] ; then
		addwrite /usr/share/NaturalDocs/Config/Languages.txt
	fi
	if [ -f /usr/share/NaturalDocs/Config/Topics.txt ] ; then
		addwrite /usr/share/NaturalDocs/Config/Topics.txt
	fi
	autotools-utils_src_prepare
}

src_configure() {
	# Needs to implemented
	local myeconfargs=( --without-selinux )
	autotools-utils_src_configure
}

AUTOTOOLS_IN_SOURCE_BUILD=1
