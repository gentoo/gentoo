# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="nanoc is a simple but very flexible static site generator written in Ruby"
HOMEPAGE="https://nanoc.ws/"
SRC_URI="https://github.com/nanoc/nanoc/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE="${IUSE} minimal"

DEPEND+="test? ( app-text/asciidoc app-text/highlight )"

RUBY_S="nanoc-${PV}/nanoc-core"

ruby_add_rdepend "
	dev-ruby/ddmemoize:1
	dev-ruby/ddmetrics:1
	dev-ruby/ddplugin:1
	=dev-ruby/hamster-3*
	>=dev-ruby/json_schema-0.19:0
	dev-ruby/slow_enumerator_tools:1
	>=dev-ruby/zeitwerk-2.1:2
"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/rspec:3
	dev-ruby/rspec-its
	dev-ruby/fuubar
	dev-ruby/minitest
	dev-ruby/timecop
	dev-ruby/yard
)
"

all_ruby_prepare() {
	# Avoid unneeded development dependencies
	sed -i -e '/simplecov/I s:^:#:' \
		-e '/codecov/I s:^:#:' ../common/spec/spec_helper_head_core.rb || die
	sed -i -e '/coverall/I s:^:#:' \
		-e '/rubocop/ s:^:#:' Rakefile || die
	sed -i -e '1i require "tmpdir"; require "pathname"' spec/spec_helper.rb || die

	echo "-r ./spec/spec_helper.rb" > .rspec || die

	sed -i -e "s:require_relative 'lib:require './lib:" ${RUBY_FAKEGEM_GEMSPEC} || die

	# Use useable tmp dir
	sed -i -e 's:/tmp/whatever:'${T}'/whatever:' spec/nanoc/core/checksummer_spec.rb || die
}

each_ruby_test() {
	RUBYLIB="${S}/lib" ${RUBY} -S rake spec || die
}
