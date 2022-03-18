# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="config"

inherit ruby-fakegem

DESCRIPTION="Text handling for Twitter"
HOMEPAGE="https://github.com/twitter/twitter-text"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~riscv"
IUSE=""

ruby_add_rdepend "
	dev-ruby/idn-ruby
	=dev-ruby/unf-0.1*
"

ruby_add_bdepend "test? ( >=dev-ruby/multi_json-1.3
	>=dev-ruby/nokogiri-1.8.0 )"

PATCHES=(
	"${FILESDIR}/${PN}-3.1.0-frozen-string.patch"
)

all_ruby_prepare() {
	#sed -i -e 's/2.14.0/2.14/' twitter-text.gemspec || die
	sed -i -e '/simplecov/,/end/ s:^:#:' spec/spec_helper.rb || die
}
