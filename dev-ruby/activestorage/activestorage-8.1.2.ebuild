# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="activestorage.gemspec"

RUBY_FAKEGEM_EXTRAINSTALL="app config db"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Attach cloud and local files in Rails applications"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

RUBY_S="rails-${PV}/${PN}"

DEPEND+=" test? ( >=app-text/mupdf-1.23.7 media-gfx/imagemagick[jpeg,png,tiff] media-video/ffmpeg app-text/poppler[utils] ) "

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}:*
	~dev-ruby/activejob-${PV}:*
	~dev-ruby/activerecord-${PV}:*
	~dev-ruby/activesupport-${PV}:*
	dev-ruby/marcel:1.0
"

ruby_add_bdepend "
	test? (
		~dev-ruby/railties-${PV}
		>=dev-ruby/image_processing-1.2:0
		dev-ruby/minitest:6
		dev-ruby/mini_magick
		dev-ruby/mocha
		dev-ruby/rake
		dev-ruby/sprockets-rails
		>=dev-ruby/sqlite3-2.1.0
		dev-ruby/webmock
	)"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -e "/\(system_timer\|pg\|execjs\|jquery-rails\|'mysql'\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|bcrypt\|uglifier\|aws-sdk-s3\|aws-sdk-sns\|google-cloud-storage\|azure-storage\|blade\|bootsnap\|hiredis\|qunit-selenium\|chromedriver-helper\|rb-inotify\|libxml-ruby\|sass-rails\|capybara\|rack-cache\|selenium\|dalli\|listen\|connection_pool\|mysql2\|webdrivers\|webpacker\|rexml\|webrick\|propshaft\|sprockets-export\|rack-test\|terser\|cookiejar\|cgi\|web-console\|trilogy\|error_highlight\|jbuilder\|httpclient\|prism\|solid\|kamal\|thruster\|releaser\)/ s:^:#:" \
		-e '/stimulus-rails/,/tailwindcss-rails/ s:^:#:' \
		-e '/group :\(cable\|doc\|job\|lint\|mdl\|rubocop\|test\)/,/^end/ s:^:#:' \
		-i ../Gemfile || die
	rm ../Gemfile.lock || die

	# Use mini_magick since vips is not packaged on Gentoo
	sed -e '/mini_magick/aActiveStorage.variant_processor = :mini_magick' \
		-i test/test_helper.rb || die
	# Avoid vips-specific tests
	sed -e '/\(resized and monochrome variation of JPEG blob\|monochrome with default variant_processor\|disabled variation of JPEG blob\)/askip "No vips support"' \
		-i test/models/variant_test.rb || die
	sed -e '/analyzing with ruby-vips unavailable/askip "No vips support"' \
		-i test/analyzer/image_analyzer/image_magick_test.rb || die
	rm -f test/analyzer/image_analyzer/vips_test.rb || die
	sed -e '/Rails.application.configure/aconfig.active_storage.variant_processor = :mini_magick' \
		-i test/dummy/config/environments/*.rb || die

	# Avoid test where different ffmpeg versions apply different rounding for the duration.
	sed -i -e '/1.022000/ s:^:#:' test/analyzer/video_analyzer_test.rb || die

	# Avoid failing test depending on yarn
	rm -f test/javascript_package_test.rb || die

	# Avoid unimportant asset configuration. This most likely fails due
	# to some kind of dependency issue.
	rm -f test/dummy/config/initializers/assets.rb || die

	# Avoid test failing due to missing (and unpackaged) AzureStorage service.
	sed -e '/azure service is deprecated/askip "Not packaged in Gentoo."' \
		-i test/service/configurator_test.rb || die
}
