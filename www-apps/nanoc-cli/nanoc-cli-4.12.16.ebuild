# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="nanoc is a simple but very flexible static site generator written in Ruby"
HOMEPAGE="https://nanoc.app/"
SRC_URI="https://github.com/nanoc/nanoc/archive/${PV}.tar.gz -> nanoc-${PV}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64 ~riscv"
SLOT="0"
IUSE="${IUSE} minimal"

RUBY_S="nanoc-${PV}/nanoc-cli"

ruby_add_rdepend "
	>=dev-ruby/cri-2.15:0
	>=dev-ruby/diff-lcs-1.3:0
	~www-apps/nanoc-core-${PV}
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
	www-servers/adsf
)
"

all_ruby_prepare() {
	# Avoid unneeded development dependencies
	sed -i -e '/simplecov/I s:^:#:' \
		-e '/codecov/I s:^:#:' ../common/spec/spec_helper_head_core.rb || die
	sed -i -e '/coverall/I s:^:#:' \
		-e '/rubocop/ s:^:#:' Rakefile || die
	sed -i -e '2i require "tmpdir"; require "pathname"' spec/spec_helper.rb || die

	echo "-r ./spec/spec_helper.rb" > .rspec || die

	sed -i -e "s:require_relative 'lib:require './lib:" ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid error handler specs failing due to different (rubygems?)
	# output, meta_spec is affected by this.
	rm -f spec/nanoc/cli/error_handler_spec.rb spec/meta_spec.rb || die

	# Avoid test requiring a network interface
	sed -i -e '/does not listen on non-local interfaces/askip "Needs network"' spec/nanoc/cli/commands/view_spec.rb || die

	# Avoid tests requiring an additional dependency on nanoc-live
	sed -i -e '/--live-reload is given/askip "Unpackaged nanoc-live"' spec/nanoc/cli/commands/view_spec.rb || die
	sed -i -e '/watches with --watch/askip "Unpackaged nanoc-live"' spec/nanoc/cli/commands/compile_spec.rb || die
}

each_ruby_test() {
	RUBYLIB="${S}/lib" ${RUBY} -S rake spec || die
}
