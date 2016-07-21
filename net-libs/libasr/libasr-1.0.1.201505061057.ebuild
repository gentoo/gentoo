# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator

DESCRIPTION="Async Resolver Library from OpenBSD/OpenSMTPD"
HOMEPAGE="https://github.com/OpenSMTPD/libasr"
SRC_URI="https://www.opensmtpd.org/archives/${PN}-$(get_version_component_range 4-).tar.gz"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-$(get_version_component_range 4-)"
