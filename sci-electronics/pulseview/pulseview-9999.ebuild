# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/pulseview/pulseview-9999.ebuild,v 1.2 2015/04/08 18:21:21 mgorny Exp $

EAPI="5"

PYTHON_COMPAT=( python3_{3,4} )
inherit eutils cmake-utils python-single-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-2
else
	SRC_URI="http://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Qt based logic analyzer GUI for sigrok"
HOMEPAGE="http://sigrok.org/wiki/PulseView"

LICENSE="GPL-3"
SLOT="0"
IUSE="+decode static"
REQUIRED_USE="decode? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/glib-2.28.0
	>=sci-libs/libsigrok-0.3.0
	dev-qt/qtgui:4
	>=dev-libs/boost-1.42
	decode? (
		>=sci-libs/libsigrokdecode-0.3.0
		${PYTHON_DEPS}
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( HACKING NEWS README )

src_configure() {
	local mycmakeargs=(
		-DDISABLE_WERROR=TRUE
		$(cmake-utils_use_enable decode DECODE)
		$(cmake-utils_use_enable static STATIC_PKGDEPS_LIBS)
	)
	cmake-utils_src_configure
}
