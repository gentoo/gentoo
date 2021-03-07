# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

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
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

DEPEND+=" test? ( app-text/mupdf media-gfx/imagemagick[jpeg,png,tiff] media-video/ffmpeg app-text/poppler[utils] ) "

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}:*
	~dev-ruby/activejob-${PV}:*
	~dev-ruby/activerecord-${PV}:*
	~dev-ruby/activesupport-${PV}:*
	>=dev-ruby/marcel-0.3.1 =dev-ruby/marcel-0.3*
	>=dev-ruby/mimemagic-0.3.2 =dev-ruby/mimemagic-0.3*
"

ruby_add_bdepend "
	test? (
		~dev-ruby/railties-${PV}
		>=dev-ruby/image_processing-1.2:0
		dev-ruby/test-unit:2
		dev-ruby/mini_magick
		dev-ruby/mocha
		dev-ruby/rake
		dev-ruby/sqlite3
	)"

all_ruby_prepare() {
	   # Remove items from the common Gemfile that we don't need for this
		# test run. This also requires handling some gemspecs.
		sed -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|execjs\|jquery-rails\|'mysql'\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|sprockets-rails\|redcarpet\|bcrypt\|uglifier\|aws-sdk-s3\|aws-sdk-sns\|google-cloud-storage\|azure-storage\|blade\|bootsnap\|hiredis\|qunit-selenium\|chromedriver-helper\|redis\|rb-inotify\|sprockets\|stackprof\|websocket-client-simple\|libxml-ruby\|sass-rails\|capybara\|rack-cache\|selenium\|json\|dalli\|listen\|connection_pool\|puma\|mysql2\|webdrivers\|webpacker\|rexml\|webmock\)/ s:^:#:" \
			-e '/dalli/ s/2.7.7/2.7.9/' \
			-e '/group :\(doc\|job\|rubocop\|test\)/,/^end/ s:^:#:' \
			-i ../Gemfile || die
		rm ../Gemfile.lock || die
}
