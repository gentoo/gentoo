# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="nanoc is a simple but very flexible static site generator written in Ruby"
HOMEPAGE="https://nanoc.app/"
SRC_URI="https://github.com/nanoc/nanoc/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64 ~riscv"
SLOT="0"
IUSE="${IUSE} minimal"

DEPEND+="test? ( app-text/asciidoc app-text/highlight )"

RUBY_S="nanoc-${PV}/nanoc-core"

ruby_add_rdepend "
	>=dev-ruby/concurrent-ruby-1.1:1
	dev-ruby/ddmetrics:1
	dev-ruby/ddplugin:1
	>=dev-ruby/immutable-ruby-0.1:0
	>=dev-ruby/json_schema-0.19:0
	>=dev-ruby/memo_wise-1.5:1
	dev-ruby/psych:0
	dev-ruby/slow_enumerator_tools:1
	>=dev-ruby/tty-platform-0.2:0
	>=dev-ruby/zeitwerk-2.1:2
"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/rspec:3
	dev-ruby/rspec-its
	dev-ruby/fuubar
	dev-ruby/minitest
	dev-ruby/timecop
	dev-ruby/tty-command
	dev-ruby/yard
	www-apps/nanoc-spec
)
"

PATCHES=( "${FILESDIR}/${PN}-4.12.2-contracts.patch" )

all_ruby_prepare() {
	# Avoid unneeded development dependencies
	sed -i -e '/simplecov/I s:^:#:' \
		-e '/codecov/I s:^:#:' ../common/spec/spec_helper_head_core.rb || die
	sed -e '/coverall/I s:^:#:' \
		-e '/rubocop/ s:^:#:' \
		-i Rakefile || die
	sed -i -e '2i require "tmpdir"; require "pathname"; gem "psych", "~> 4.0"' spec/spec_helper.rb || die

	echo "-r ./spec/spec_helper.rb" > .rspec || die

	sed -i -e "s:require_relative 'lib:require './lib:" ${RUBY_FAKEGEM_GEMSPEC} || die

	# Use useable tmp dir
	sed -i -e "s:/tmp/whatever:${T}/whatever:" spec/nanoc/core/checksummer_spec.rb || die

	# Avoid circular dependency on www-apps/nanoc
	sed -i -e '/.all_outdated/,/^  end/ s:^:#:' spec/nanoc/core/feature_spec.rb || die
	rm -f spec/nanoc/core_spec.rb || die
}

each_ruby_test() {
	RUBYLIB="${S}/lib" ${RUBY} -S rake spec || die
}
