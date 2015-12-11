# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Colour management with Ruby"
HOMEPAGE="https://github.com/halostatue/color"
SRC_URI="https://github.com/halostatue/color/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "
	test? (
		>=dev-ruby/minitest-5.0
	)"

each_ruby_test() {
	${RUBY} -Ilib:test:. -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}
