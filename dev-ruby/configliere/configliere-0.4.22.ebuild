# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.textile README.textile FEATURES.txt"

inherit ruby-fakegem

DESCRIPTION="Settings manager for Ruby scripts"
HOMEPAGE="https://github.com/infochimps-labs/configliere"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/highline-1.5.2
	>=dev-ruby/multi_json-1.10.1"

all_ruby_prepare() {
	rm Gemfile* || die
	sed -i -e "/bundler/d" spec/spec_helper.rb || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r examples
}
