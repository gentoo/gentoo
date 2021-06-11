# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Multi-polynomial quadratic sieve for integer factorization"
HOMEPAGE="https://github.com/sagemath/FlintQS"
# The github tarball is missing the autotools stuff.
SRC_URI="http://files.sagemath.org/spkg/upstream/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

DEPEND="dev-libs/gmp:="
RDEPEND="${DEPEND}"

src_test() {
	# Factor,
	#
	#   1000000000000000005490000000000000001989
	#
	# to get
	#
	#   10000000000000000051 * 100000000000000000039.
	#
	# The sed command deletes all lines up to the pattern match.
	#
	ACTUAL=$(echo 1000000000000000005490000000000000001989 | \
				 "${S}"/src/QuadraticSieve | \
				 sed '0,/FACTORS:/d' | \
				 sort --numeric | \
				 uniq |
				 tr '\n' ' ')
	EXPECTED="10000000000000000051 100000000000000000039 "

	[[ "${ACTUAL}" == "${EXPECTED}" ]] || die "test factorization failed"
}
