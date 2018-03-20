# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

inherit ruby-fakegem

DESCRIPTION="Makes http fun! Also, makes consuming restful web services dead easy"
HOMEPAGE="https://jnunemaker.github.com/httparty"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend '>=dev-ruby/multi_xml-0.5.2'

ruby_add_bdepend 'test? ( dev-ruby/webmock )'

all_ruby_prepare() {
	# Remove bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/ s:^:#:' Rakefile || die

	# Avoid test dependency on cucumber. We can't run the features since
	# they depend on mongrel which is no longer packaged.
	sed -i -e '/cucumber/I s:^:#:' Rakefile || die

	# Avoid test dependency on simplecov
	sed -i -e '/simplecov/I s:^:#:' \
		-e '1i require "cgi"; require "delegate"' spec/spec_helper.rb || die

	# Avoid test that works standalone but fails in the suite
	sed -i -e '/calls block given to perform with each redirect/,/^        end/ s:^:#:' spec/httparty/request_spec.rb
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*
}
