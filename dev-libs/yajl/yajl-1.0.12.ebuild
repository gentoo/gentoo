# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-multilib vcs-snapshot

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="https://lloyd.github.com/yajl/"
SRC_URI="https://github.com/lloyd/yajl/tarball/${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"

IUSE=""

multilib_src_test() {
	emake test
}
