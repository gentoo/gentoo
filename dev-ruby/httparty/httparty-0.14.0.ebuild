# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md History"

inherit ruby-fakegem

DESCRIPTION="Makes http fun! Also, makes consuming restful web services dead easy"
HOMEPAGE="https://jnunemaker.github.com/httparty"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

ruby_add_rdepend '>=dev-ruby/multi_xml-0.5.2'

ruby_add_bdepend 'test? ( dev-ruby/fakeweb )'

all_ruby_prepare() {
	# Remove bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/ s:^:#:' Rakefile || die

	# Avoid test dependency on cucumber. We can't run the features since
	# they depend on mongrel which is no longer packaged.
	sed -i -e '/cucumber/I s:^:#:' Rakefile || die

	# Avoid test dependency on simplecov
	sed -i -e '/simplecov/I s:^:#:' \
		-e '1i require "cgi"' spec/spec_helper.rb || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*
}
