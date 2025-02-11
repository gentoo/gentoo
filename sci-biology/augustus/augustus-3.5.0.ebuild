# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_CONFIG_NAME="doxygen.conf"

PYTHON_COMPAT=( python3_{12..13} )

inherit docs python-any-r1 toolchain-funcs

DESCRIPTION="Eukaryotic gene predictor"
HOMEPAGE="https://bioinf.uni-greifswald.de/augustus/"
SRC_URI="https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite:3
	dev-db/mysql++:=
	dev-db/mysql-connector-c:=
	dev-libs/boost:=[zlib]
	sci-biology/bamtools:=
	sci-biology/samtools:0
	sci-libs/gsl:=
	sci-libs/htslib:=
	sci-libs/suitesparse
	sci-mathematics/lpsolve:=
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		${PYTHON_DEPS}
	)
"

PATCHES=(
	"${FILESDIR}"/augustus-3.4.0-missing-cstdint.patch
	"${FILESDIR}"/augustus-3.5.0-fix-gcc15.patch
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_compile() {
	tc-export CC CXX AR

	emake

	# Vendored gtest
	use test && emake -C src unittest

	docs_compile
}

src_test() {
	if use elibc_musl; then
		# Upstream already does this for non-amd64 and non-linux environments
		# Probably related https://github.com/Gaius-Augustus/Augustus/issues/247
		# bug #873025
		emake test TEST_COMPARE= TEST_HTML=
	else
		emake test
	fi

	pushd src/unittests >/dev/null || die
	if use elibc_musl; then
		# Float issues
		./unittests --gtest_filter='-CodonEvoTest.CodonEvoRateReadWrite' || die
	else
		./unittests || die
	fi
	popd >/dev/null || die
}

src_install() {
	einstalldocs
	# from upstream Makefile install:
	dodir "opt/${P}"
	cp -a config bin scripts "${ED}/opt/${P}" || die
	local file
	for file in bin/*; do
		dosym "../${P}/${file}" "/opt/${file}"
	done
}
