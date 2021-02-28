# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Algorithmic inferencing of XML schema definitions and DTDs"
HOMEPAGE="https://github.com/kore/XML-Schema-learner"
SRC_URI="https://github.com/kore/XML-Schema-learner/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

# This test suite used to work but needs an update for modern versions
# of PHPUnit. See https://github.com/kore/XML-Schema-learner/issues/6
RESTRICT="test"

# PHP dependency can be inferred from .travis.yml in the repository.
# The necessary USE flags on the other hand were found the hard way.
#
# The dependencies here aren't as expressive as they should be. What we
# really want is for php[...] to apply to everything in PHP_TARGETS, and
# for those interpreters (the ones in PHP_TARGETS) to be used to run the
# test suite.
#
# See bug #497606.
#
RDEPEND="dev-lang/php:*[cli,xml,xmlreader]"
DEPEND="test? ( ${RDEPEND}
				dev-php/phpunit )"

src_compile() {
	# Don't run make, the default target is 'check'.
	:
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	dodoc README.rst
}
