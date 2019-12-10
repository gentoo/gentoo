# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Linux application container management from Google"
HOMEPAGE="https://github.com/google/lmctfy"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/protobuf
	>=dev-cpp/gflags-2.1.1
	dev-libs/re2
	dev-lang/go
	sys-libs/libapparmor
	"
RDEPEND="${DEPEND}"

src_compile() {
	# test deps take too long to compile
	use test && emake || emake lmctfy liblmctfy.a
}

src_install() {
	dobin bin/lmctfy/cli/lmctfy
	dolib.a bin/liblmctfy.a
}
