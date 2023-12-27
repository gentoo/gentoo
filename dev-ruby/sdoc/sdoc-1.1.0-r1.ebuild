# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

inherit ruby-fakegem

DESCRIPTION="rdoc generator html with javascript search index"
HOMEPAGE="https://rubygems.org/gems/sdoc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ppc ~riscv ~sparc ~x86"

ruby_add_rdepend ">=dev-ruby/rdoc-5.0"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/ s:^:#:' sdoc.gemspec || die

	sed -i -e '/bundler/I s:^:#:' Rakefile spec/spec_helper.rb || die

	# Avoid spec that appears to be broken with newer rdoc versions.
	sed -i -e '/should display SDoc version/askip' spec/rdoc_generator_spec.rb || die
}

each_ruby_test() {
	${RUBY} -I lib:spec:. -e 'Dir["spec/*_spec.rb"].each { require _1 }' || die
}
