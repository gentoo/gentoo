# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="vendor"

inherit ruby-fakegem

DESCRIPTION="Add vendor prefixes to CSS rules using values from the Can I Use website"
HOMEPAGE="https://github.com/ai/autoprefixer-rails"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"
IUSE=""

ruby_add_rdepend "dev-ruby/execjs:*"

ruby_add_bdepend "test? (
	>=dev-ruby/rails-5.0.0
	dev-ruby/rake
	dev-ruby/rspec-rails
)"

all_ruby_prepare() {
	sed -i -e "/bundler/d" -e "/BUNDLE/d" spec/app/config/boot.rb || die
	sed -i -e "/Bundler/,+3d" \
		-e '/config.sass/ s:^:#:' spec/app/config/application.rb || die
	sed -i -e '/standard/ s:^:#:' autoprefixer-rails.gemspec || die
	rm -f spec/rails_spec.rb || die
}
