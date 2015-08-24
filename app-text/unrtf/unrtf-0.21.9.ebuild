# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="Converts RTF files to various formats"
HOMEPAGE="https://www.gnu.org/software/unrtf/unrtf.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
IUSE=""

src_prepare() {
	# eautoreconf fails when automake-1.14* is installed. Please check with
	# next version bump if we still need this workaround.
	rm aclocal.m4 || die

	epatch "${FILESDIR}"/unrtf-0.21.8-automake-fix.patch
	epatch "${FILESDIR}"/${PN}-0.21.8-iconv-detection.patch
	eautoreconf
}
