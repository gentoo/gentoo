# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="git://anongit.freedesktop.org/git/libreoffice/libetonyek"
inherit eutils
[[ ${PV} == 9999 ]] && inherit autotools git-r3

DESCRIPTION="Library parsing Apple Keynote presentations"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
[[ ${PV} == 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="|| ( GPL-2+ LGPL-2.1 MPL-1.1 )"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc static-libs test"

RDEPEND="
	app-text/liblangtag
	dev-libs/librevenge
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-util/mdds:1
	media-libs/glm
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

pkg_pretend() {
	if [[ $(gcc-major-version) -lt 4 ]] || {
		[[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 8 ]]; }
	then
		eerror "Compilation with gcc older than 4.8 is not supported"
		die "Too old gcc found."
	fi
}

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable static-libs static) \
		--disable-werror \
		$(use_enable test tests) \
		$(use_with doc docs)
}

src_install() {
	default
	prune_libtool_files --all
}
