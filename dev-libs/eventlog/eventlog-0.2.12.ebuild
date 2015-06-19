# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/eventlog/eventlog-0.2.12.ebuild,v 1.12 2015/03/30 20:34:29 mr_bones_ Exp $

EAPI=5
inherit libtool eutils

DESCRIPTION="Support library for syslog-ng"
HOMEPAGE="http://www.balabit.com/products/syslog_ng/"
SRC_URI="http://www.balabit.com/downloads/files/eventlog/0.2//eventlog_${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~m68k-mint"
IUSE="static-libs"

DEPEND=""

src_prepare() {
	elibtoolize
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	DOCS="AUTHORS CREDITS ChangeLog NEWS PORTS README" \
		default
	prune_libtool_files
}
