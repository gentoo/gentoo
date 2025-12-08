# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_TEST="CUCUMBER_PUBLISH_QUIET=true test features"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.adoc README.adoc"

RUBY_FAKEGEM_EXTRAINSTALL="data"

RUBY_FAKEGEM_GEMSPEC="asciidoctor.gemspec"

inherit ruby-fakegem

DESCRIPTION="Processor for converting AsciiDoc into HTML 5, DocBook 4.5 and other formats"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv x86"
IUSE="test"

PATCHES=( "${FILESDIR}/${P}-ruby34.patch" )

ruby_add_bdepend "test? (
	dev-util/cucumber
	dev-ruby/rspec-expectations:*
	dev-ruby/asciimath
	dev-ruby/coderay
	dev-ruby/concurrent-ruby
	dev-ruby/erubi
	dev-ruby/haml:6
	dev-ruby/nokogiri
	dev-ruby/rouge
	dev-ruby/slim
	dev-ruby/tilt )"

all_ruby_prepare() {
	rm Gemfile || die

	sed -i -e "s:_relative ': './:" ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid broken blocks_test.rb (already appears to be fixed upstream)
	rm -f test/blocks_test.rb || die

	# Avoid test depending on haml 6 binary which we currently don't install.
	sed -e '/should \(load\|locate\) custom templates/askip "wrong haml binary"' \
		-i test/invoker_test.rb || die

	# Add missing require for URI
	sed -e "/nokogiri/arequire 'uri'" \
		-i test/test_helper.rb || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/asciidoctor.1
}
