# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="HISTORY.txt README"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A small PEG based parser library"
HOMEPAGE="https://github.com/kschiess/parslet"
SRC_URI="https://github.com/kschiess/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend ">=dev-ruby/blankslate-2"

ruby_add_bdepend "test? ( dev-ruby/flexmock )"

all_ruby_prepare() {
	sed -i -e "/sdoc/d" Rakefile || die
	# Avoid spec calling out to ruby since we can't guarantee the
	# correct version of blankslate in this case.
	rm spec/acceptance/examples_spec.rb || die
}
