# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

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
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE=""

ruby_add_bdepend "test? (
	dev-util/cucumber
	dev-ruby/rspec-expectations:*
	dev-ruby/asciimath
	dev-ruby/coderay
	dev-ruby/concurrent-ruby
	dev-ruby/erubi
	dev-ruby/haml
	dev-ruby/nokogiri
	dev-ruby/rouge
	dev-ruby/slim
	dev-ruby/tilt )"

all_ruby_prepare() {
	rm Gemfile || die

	sed -i -e "s:_relative ': './:" ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid broken blocks_test.rb (already appears to be fixed upstream)
	rm -f test/blocks_test.rb || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/asciidoctor.1
}
