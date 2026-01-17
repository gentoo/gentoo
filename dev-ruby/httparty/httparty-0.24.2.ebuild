# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

RUBY_FAKEGEM_GEMSPEC="httparty.gemspec"

inherit ruby-fakegem

DESCRIPTION="Makes http fun! Also, makes consuming restful web services dead easy"
HOMEPAGE="https://www.johnnunemaker.com/httparty/"
SRC_URI="https://github.com/jnunemaker/httparty/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

ruby_add_rdepend "
	dev-ruby/csv
	>=dev-ruby/mini_mime-1.0.0
	>=dev-ruby/multi_xml-0.5.2
"

ruby_add_bdepend 'test? ( dev-ruby/webmock )'

all_ruby_prepare() {
	sed -i -e 's/git ls-files \?-\?-\?/find/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Remove bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/ s:^:#:' Rakefile || die

	# Avoid test dependency on cucumber. We can't run the features since
	# they depend on mongrel which is no longer packaged.
	sed -i -e '/cucumber/I s:^:#:' Rakefile || die

	# Avoid test dependency on simplecov
	sed -i -e '/simplecov/I s:^:#:' \
		-e '/pry/ s:^:#:' \
		-e '1i require "cgi"; require "delegate"' spec/spec_helper.rb || die

	# Avoid test that works standalone but fails in the suite
	#sed -i -e '/calls block given to perform with each redirect/,/^        end/ s:^:#:' spec/httparty/request_spec.rb

	# Avoid test that is not fully compatible with newer multi_xml
	sed -i -e '/should be able parse response type xml automatically/askip "multi_xml"' spec/httparty_spec.rb || die

	# Avoid test that fails due to unicode normalization differences
	sed -i -e '/handles international domains/askip "unicode differences"' spec/httparty_spec.rb || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*
}
