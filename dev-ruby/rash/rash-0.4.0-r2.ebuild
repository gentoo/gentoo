# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Rash is an extension to Hashie"
HOMEPAGE="https://github.com/tcocca/rash"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/hashie-2.0.0:0"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die

	sed -i -e '/hashie/ s/2.0.0/2.0/' \
		-e '/git ls-files/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die
}
