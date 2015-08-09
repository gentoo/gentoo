# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Algorithmic inferencing of XML schema definitions and DTDs"
HOMEPAGE="https://github.com/kore/${PN}"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"

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
