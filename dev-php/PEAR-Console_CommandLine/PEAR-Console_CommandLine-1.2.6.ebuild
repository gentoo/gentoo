# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A full-featured command-line options and arguments parser"
HOMEPAGE="https://pear.php.net/package/Console_CommandLine"
SRC_URI="https://github.com/pear/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ppc64 ~sparc x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/php:*
	dev-php/PEAR-Exception"

# Beware, the test suite really needs PEAR-PEAR.
BDEPEND="test? ( ${RDEPEND} dev-php/PEAR-PEAR )"

src_prepare() {
	# There's one occurrence of @data_dir@ that needs to be replaced
	# This location just has to agree with where we put the "data"
	# directory during src_install().
	default
	sed -i "s|@data_dir@|${EPREFIX}/usr/share|" \
		Console/CommandLine/XmlParser.php || die

	# These two fail, but only due to the ordering of the associative
	# arrays in the expected output. Github issue tracking is disabled
	# but the current maintainer of the repo has been emailed about it.
	rm tests/console_commandline_{addargument,addoption}.phpt || die
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
