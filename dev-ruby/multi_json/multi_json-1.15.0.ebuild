# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC="yard"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="multi_json.gemspec"

inherit ruby-fakegem

SRC_URI="https://github.com/intridea/multi_json/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="A gem to provide swappable JSON backends"
HOMEPAGE="https://github.com/intridea/multi_json"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

ruby_add_rdepend "|| ( >=dev-ruby/json-1.4:* >=dev-ruby/yajl-ruby-1.0 )"

ruby_add_bdepend "doc? ( dev-ruby/rspec:3 dev-ruby/yard )"

ruby_add_bdepend "test? ( dev-ruby/json
	dev-ruby/yajl-ruby )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' Rakefile spec/spec_helper.rb || die "Unable to remove bundler."

	# Remove unimportant rspec options not supported by rspec 2.6.
	rm .rspec || die

	# Remove specs specific to oj since we don't package oj yet.
	sed -i -e '/defaults to the best available gem/,/^  end/ s:^:#:' \
		-e '/Oj does not create symbols on parse/,/^    end/ s:^:#:' \
		-e '/with Oj.default_settings/,/^    end/ s:^:#:' \
		-e '/using one-shot parser/,/^  end/ s:^:#:' \
		-e '/jrjackson/askip "unpackaged"' \
		spec/multi_json_spec.rb

	# Avoid simplecov which only works with ruby 1.9
	sed -i -e '/simplecov/d' -e '/SimpleCov.formatter/,/SimpleCov.start/ d' spec/spec_helper.rb || die

	# Remove unpackaged and for our purposes unneeded coveralls
	sed -i -e '/coveralls/d' spec/spec_helper.rb || die

	# Avoid testing unpackaged adapters
	rm spec/{gson,nsjsonserialization,jr_jackson,oj}_adapter_spec.rb || die
}

each_ruby_test() {
	for t in spec/*_spec.rb; do
		${RUBY} -S rspec-3 ${t} || die
	done
}
