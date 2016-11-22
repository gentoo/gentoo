# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools versionator

MY_P="${P/_rc/-rc}"
MY_SLOT="$(get_version_component_range 1-2)"

DESCRIPTION="Linux Trace Toolkit - UST library"
HOMEPAGE="http://lttng.org"
SRC_URI="http://lttng.org/files/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/${MY_SLOT}"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="examples"

DEPEND="dev-libs/userspace-rcu"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	if ! use examples; then
		sed -i -e '/SUBDIRS/s:examples::' doc/Makefile.am || die
	fi
	eautoreconf
}
