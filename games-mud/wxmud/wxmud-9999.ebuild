# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER=2.8
PYTHON_COMPAT=( python2_7 )
inherit flag-o-matic subversion wxwidgets autotools python-single-r1

DESCRIPTION="Cross-platform MUD client"
HOMEPAGE="http://wxmud.sourceforge.net/"
SRC_URI=""
ESVN_REPO_URI="https://wxmud.svn.sourceforge.net/svnroot/wxmud/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="python"

RDEPEND="
	>=x11-libs/gtk+-2.4:2
	x11-libs/wxGTK:${WX_GTK_VER}
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	subversion_src_unpack
	cd "${S}" || die
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing
	# No audiere in portage yet, so useful MSP support is disabled for now
	econf \
		--with-wx-config="${WX_CONFIG}" \
		$(use_enable python) \
		--disable-audiere
}

src_compile() {
	emake
}

src_install() {
	default
	dodoc docs/input.txt docs/scripting.txt
}
