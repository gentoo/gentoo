# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A full-featured command-line options and arguments parser"
HOMEPAGE="https://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

# Only needs PEAR_Exception (not yet packaged) -- not all of PEAR-PEAR.
RDEPEND="dev-lang/php:*
	dev-php/PEAR-PEAR"

# Beware, the test suite really needs PEAR-PEAR.
DEPEND="test? ( ${RDEPEND} )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# There's one occurrence of @data_dir@ that needs to be replaced
	# This location just has to agree with where we put the "data"
	# directory during src_install().
	default
	sed -i "s|@data_dir@|${EPREFIX}/usr/share|" \
		Console/CommandLine/XmlParser.php || die
}

src_install() {
	use examples && dodoc -r docs/examples

	insinto "/usr/share/${MY_PN}"
	doins -r data

	insinto /usr/share/php
	doins -r Console
}

src_test() {
	# Requires the "pear" executable from dev-php/PEAR-PEAR.
	pear run-tests tests || die

	# The command succeeds regardless of whether or not the test suite
	# passed, but this file is only written when there was a failure.
	[[ -f run-tests.log ]] && die "test suite failed"
}
