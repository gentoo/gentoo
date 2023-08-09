# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31"

inherit ruby-fakegem

RUBY_FAKEGEM_EXTRADOC="README.markdown History.markdown"
RUBY_FAKEGEM_EXTRAINSTALL="features"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_BINDIR="exe"

DESCRIPTION="Simple, blog aware, static site generator"
HOMEPAGE="https://jekyllrb.com https://github.com/jekyll/jekyll"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz  -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/addressable-2.4
	>=dev-ruby/colorator-1.0
	>=dev-ruby/em-websocket-0.5
	dev-ruby/i18n:1
	>=dev-ruby/kramdown-2.3:2
	dev-ruby/kramdown-parser-gfm:1
	dev-ruby/liquid:4
	>=dev-ruby/mercenary-0.4.0
	>=dev-ruby/pathutil-0.9
	|| ( dev-ruby/rouge:4 dev-ruby/rouge:2 )
	|| ( dev-ruby/terminal-table:3 dev-ruby/terminal-table:2 )
	>=dev-ruby/webrick-1.7:0
	>=www-apps/jekyll-sass-converter-2.0
	>=www-apps/jekyll-watch-2.2.1-r1
"
ruby_add_bdepend "
	test? (
		dev-ruby/httpclient
		dev-ruby/kramdown-syntax-coderay
		dev-ruby/launchy
		dev-ruby/nokogiri
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
	eapply -R "${FILESDIR}/${P}-sass.patch"
	eapply "${FILESDIR}"/jekyll-4.3.2-no-safe_yaml.patch

	# Drop tests requiring bundler
	sed -i -e '/bundle_message/d' test/test_new_command.rb || die
	rm test/test_plugin_manager.rb || die

	# Drop tests requiring classifier-reborn (ruby27-only package)
	rm -f test/test_related_posts.rb || die

	# Replace git command in gemspec
	sed -e 's/git ls-files/find -not -type d -print/' \
		-e 's:_relative ": "./:' \
		-i $RUBY_FAKEGEM_GEMSPEC || die

	# FIXMEs:
	# fails to find fixtures because this requires bundler
	rm -f test/test_theme.rb || die
	rm -f test/test_theme_{assets_reader,data_reader,drop}.rb || die
	sed -i -e '/^    should.*theme/,/^    end$/d' \
		-e '/^      should.*theme/,/^      end$/d' test/test_site.rb || die
	sed -i -e '/context "with a theme"/,/^    end/ s:^:#:' test/test_layout_reader.rb || die
	sed -i -e '/normalize paths of rendered items/askip "test-theme"' test/test_liquid_renderer.rb || die
	# partially requires 'toml'
	rm test/test_configuration.rb || die
	# pygments tests fail because of line numbering
	sed -i -e '/^  context.*pygments/,/^  end$/d' test/test_tags.rb || die
	#sed -i -e '/^    context.*pygments/,/^    end$/d' test/test_redcarpet.rb || die

	# Tries to use bundler and install packages.
	rm -f test/test_new_command.rb || die

	# Fails due to ordering differences in ruby 3.0
	sed -e '/convert drop to json/askip "hash ordering with ruby 3"' \
		-i test/test_filters.rb || die

	# Avoid a test failing due to TZ differences
	sed -e '/contain the proper page data to mimic the post liquid/askip "TZ difference"' \
		-i test/test_excerpt.rb || die

	# Confused by network-sandbox
	sed -e "/return true if there's internet/askip \"Confused by network-sandbox\"" \
		-i test/test_utils.rb || die
}

src_test() {
	local -x JEKYLL_NO_BUNDLER_REQUIRE=true

	ruby-ng_src_test
}
