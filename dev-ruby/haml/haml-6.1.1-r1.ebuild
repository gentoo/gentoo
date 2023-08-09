# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTENSIONS=(ext/haml/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/haml"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md FAQ.md README.md REFERENCE.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A ruby web page templating engine"
HOMEPAGE="https://haml.info/"
SRC_URI="https://github.com/haml/haml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm arm64 ~hppa ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

IUSE="doc test"

ruby_add_rdepend ">=dev-ruby/temple-0.8.2 dev-ruby/thor dev-ruby/tilt:*"

ruby_add_bdepend "
	test? (
		dev-ruby/minitest:5.15
		dev-ruby/nokogiri
		>=dev-ruby/railties-6.0
		>=dev-ruby/activemodel-6.0
		>=dev-ruby/actionpack-6.0
		dev-ruby/unindent
	)
	doc? (
		dev-ruby/yard
	)"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/bundler/ s:^:#: ; /Bundler/,/end/ s:^:#:' Rakefile || die
	# minitest hack just to match rails/activesupport
	sed -i \
		-e "/require 'minitest\/autorun'/igem 'minitest', '< 5.16'" \
		-e '/bundler/I s:^:#:' \
		-e '/simplecov/I s:^:#:' \
		test/test_helper.rb || die
	# Remove tests that fails when RedCloth is available
	rm -f test/haml/filters/markdown_test.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -rtest_helper -e 'Dir["test/haml/**/*_test.rb"].each { require _1 }' || die
}
