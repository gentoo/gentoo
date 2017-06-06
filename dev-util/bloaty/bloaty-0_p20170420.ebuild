# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot toolchain-funcs

COMMIT="73594cde8c9a52a102c4341c244c833aa61b9c06"

DESCRIPTION="A size profiler for binaries"
HOMEPAGE="https://github.com/google/bloaty"
SRC_URI="https://github.com/google/bloaty/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/re2-0.2017.03.01"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i -e "s#\$(RE2_[AH])##"\
		-e "s#\tar #\t$(tc-getAR) #"\
		-e "s#-lpthread#-lre2 -lpthread#"\
		-e "/^CXXFLAGS/ s#-I third_party/re2##"\
		Makefile || die
}

src_compile() {
	CXX=$(tc-getCXX) emake
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
