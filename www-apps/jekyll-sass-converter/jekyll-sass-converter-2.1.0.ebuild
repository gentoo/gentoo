# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md History.markdown"

RUBY_FAKEGEM_GEMSPEC="jekyll-sass-converter.gemspec"

inherit ruby-fakegem

DESCRIPTION="A basic Sass converter for Jekyll"
HOMEPAGE="https://github.com/jekyll/jekyll-sass-converter"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/sassc-2.0.1:2"
ruby_add_bdepend "test? ( >=www-apps/jekyll-2 )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find -type f -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e "1irequire 'tmpdir'" spec/scss_converter_spec.rb || die

	# Avoid specs that require the minima theme
	sed -i -e '/with valid sass paths in a theme/,/^  end/ s:^:#:' spec/scss_converter_spec.rb || die
}
