# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils rpm versionator autotools

MY_PV=$(get_version_component_range 1-2)
MY_P="${PN}-${MY_PV}"
RPM_PV=$(get_version_component_range 3)
FC_PV=$(get_version_component_range 4)

DESCRIPTION="pax (Portable Archive eXchange) is the POSIX standard archive tool"
HOMEPAGE="http://cvsweb.openbsd.org/cgi-bin/cvsweb/src/bin/pax/"
SRC_URI="mirror://fedora-dev/releases/${FC_PV}/Everything/source/SRPMS/${MY_P}-${RPM_PV}.fc${FC_PV}.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	rpm_spec_epatch ../${PN}.spec
	epatch "${FILESDIR}"/pax-3.4-x32.patch
	epatch "${FILESDIR}"/pax-3.4-sysmacros.patch
	sed -i configure.in -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	eautoreconf
}

src_install() {
	default
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
