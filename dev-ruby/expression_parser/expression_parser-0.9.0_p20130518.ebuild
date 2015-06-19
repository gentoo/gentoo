# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/expression_parser/expression_parser-0.9.0_p20130518.ebuild,v 1.2 2015/03/20 13:53:03 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README"
RUBY_FAKEGEM_VERSION="0.9.0.20130518"

inherit ruby-fakegem

DESCRIPTION="A math parser"
HOMEPAGE="http://lukaszwrobel.pl/blog/math-parser-part-3-implementation"
COMMIT_ID="6e3c7973423ff0f2cd33db2304fcd4eac3af01ad"
SRC_URI="https://github.com/nricciar/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

RUBY_S="${PN}-${COMMIT_ID}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
