# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools
DESCRIPTION="Simple RFC-complient TELNET implementation as a C library"
HOMEPAGE="https://github.com/seanmiddleditch/libtelnet"

if [ ${PV} = 9999 ]; then
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/seanmiddleditch/${PN}.git"
	inherit git-2
	DEPEND="dev-vcs/git"
	S="${WORKDIR}/${PN}-master"
else
	KEYWORDS="~x86 ~amd64"
	SRC_URI="https://github.com/seanmiddleditch/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

WANT_AUTOMAKE=1.11
DEPEND="${DEPEND} sys-devel/automake:${WANT_AUTOMAKE}"
LICENSE="public-domain"
SLOT="0"
IUSE=""
RDEPEND=""

src_prepare() {
	_elibtoolize
	eaclocal
	eautoconf
	eautoheader
	eautomake
}
