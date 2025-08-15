# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_COMMIT="428802d1a5634f96bcd0705fab379ff0113bcf13"

DESCRIPTION="Family of better random number generators"
HOMEPAGE="https://www.pcg-random.org https://github.com/imneme/pcg-cpp"
SRC_URI="https://github.com/imneme/pcg-cpp/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/pcg-cpp-${MY_COMMIT}"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/pcg-cpp-0.98.1-testerror.patch
)

# header-only library
src_compile() {
	tc-export CXX
	if use test ; then
		cd test-high || die
		emake
	fi
}

src_test() {
	cd test-high || die
	sh ./run-tests.sh || die
}

src_install() {
	doheader include/*
}
