# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

inherit ruby-fakegem

RUBY_FAKEGEM_EXTRADOC="README.markdown History.markdown"
RUBY_FAKEGEM_EXTRAINSTALL="features"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_BINDIR="exe"

DESCRIPTION="A simple, blog aware, static site generator"
HOMEPAGE="https://jekyllrb.com https://github.com/jekyll/jekyll"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz  -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/addressable-2.4
	>=dev-ruby/colorator-1.0i
	>=dev-ruby/em-websocket-0.5
	>=dev-ruby/i18n-0.7:0.7
	>=dev-ruby/kramdown-1.14
	>=dev-ruby/liquid-4.0:4
	>=dev-ruby/mercenary-0.3.3
	>=dev-ruby/pathutil-0.9
	>=dev-ruby/safe_yaml-1.0
	|| ( dev-ruby/rouge:2 >=dev-ruby/rouge-1.7:0 )
	>=www-apps/jekyll-sass-converter-1.0
	>=www-apps/jekyll-watch-2.0
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/classifier-reborn-2.1.0
		dev-ruby/launchy
		>=dev-ruby/pygments_rb-0.6.0
		>=dev-ruby/rdiscount-2.0
		>=dev-ruby/redcarpet-3.2.3
		dev-ruby/rspec-mocks
		>=dev-ruby/shoulda-3
		dev-ruby/test-unit:2
		www-apps/jekyll-coffeescript
	)
"

all_ruby_prepare() {
	eapply "${FILESDIR}"/jekyll-3.6.0-test-helper.patch

	# Drop tests requiring bundler
	sed -i -e '/bundle_message/d' test/test_new_command.rb || die
	rm test/test_plugin_manager.rb || die

	# Replace git command in gemspec
	sed -i 's/git ls-files -z/find -not -type d -print0/' $RUBY_FAKEGEM_GEMSPEC || die

	# FIXMEs:
	# fails to find fixtures
	rm test/test_theme.rb || die
	rm test/test_theme_assets_reader.rb || die
	sed -i -e '/^    should.*theme/,/^    end$/d' \
		-e '/^      should.*theme/,/^      end$/d' test/test_site.rb || die
	# partially requires 'toml'
	rm test/test_configuration.rb || die
	# pygments tests fail because of line numbering
	sed -i -e '/^  context.*pygments/,/^  end$/d' test/test_tags.rb || die
	sed -i -e '/^    context.*pygments/,/^    end$/d' test/test_redcarpet.rb || die
}

src_test() {
	local -x JEKYLL_NO_BUNDLER_REQUIRE=true

	ruby-ng_src_test
}
