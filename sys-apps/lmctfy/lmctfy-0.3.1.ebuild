# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Linux application container management from Google"
HOMEPAGE="https://github.com/google/lmctfy"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-libs/protobuf
	dev-cpp/gflags
	dev-libs/re2
	"
RDEPEND="${DEPEND}"

src_compile() {
	# test deps take too long to compile
	use test && emake || emake lmctfy liblmctfy.a
}

src_install() {
	# silly upstream!
	mkdir -p "${D}/usr/bin"
	cp "${S}/bin/lmctfy/cli/lmctfy" "${D}/usr/bin/" || die "Failed to copy cli binary"
	dolib.a "${S}/bin/liblmctfy.a" || die "Failed to copy library"
}
