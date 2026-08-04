# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_EXTRAINSTALL="app config db"
RUBY_FAKEGEM_GEMSPEC="activestorage.gemspec"
RUBY_FAKEGEM_RECIPE_DOC=""

inherit ruby-fakegem

DESCRIPTION="Attach cloud and local files in Rails applications"
HOMEPAGE="https://github.com/rails/rails"

SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"
RUBY_S="rails-${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}:*
	~dev-ruby/activejob-${PV}:*
	~dev-ruby/activerecord-${PV}:*
	~dev-ruby/activesupport-${PV}:*
	dev-ruby/marcel:1.0
"
ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		>=dev-ruby/image_processing-1.2:0
		dev-ruby/mini_magick
		dev-ruby/minitest:6
		dev-ruby/minitest-mock
		>=dev-ruby/ruby-vips-2.3
		>=dev-ruby/sprockets-rails-2.0.0
		>=dev-ruby/sqlite3-2.1
		dev-ruby/webmock
	)
"
BDEPEND+="
	test? (
		>=app-text/mupdf-1.23.7
		app-text/poppler[utils]
		media-gfx/imagemagick[jpeg,png,tiff]
		media-libs/vips[imagemagick]
		media-video/ffmpeg
	)
"

all_ruby_prepare() {
	# Replace Gemfile with something simpler for the test run
	cat <<-EOF > ../Gemfile || die
	source "https://rubygems.org"
	gemspec

	gem "rake"

	gem "minitest", "~> 6.0"
	gem "minitest-mock"

	gem "image_processing", "~> 1.2"
	gem "mini_magick"
	gem "ruby-vips"
	gem "sprockets-rails", ">= 2.0.0"
	gem "sqlite3", ">= 2.1"
	gem "webmock"
	EOF
	rm ../Gemfile.lock || die

	# Avoid failing test depending on yarn
	rm -f test/javascript_package_test.rb || die

	# Needs vips[gif] that isn't hooked up
	sed -e '/"optimized variation of GIF blob"/,/^  end/ s:^:#:' \
		-e '/"thumbnail variation of extensionless GIF blob processed with VIPS"/,/^  end/ s:^:#:' \
		-i test/models/variant_test.rb || die
}
