# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="vendor"

RUBY_FAKEGEM_GEMSPEC="autoprefixer-rails.gemspec"

inherit ruby-fakegem

DESCRIPTION="Add vendor prefixes to CSS rules using values from the Can I Use website"
HOMEPAGE="https://github.com/ai/autoprefixer-rails"
SRC_URI="https://github.com/ai/autoprefixer-rails/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"
IUSE=""

DEPEND+="test? ( net-libs/nodejs )"

ruby_add_rdepend "dev-ruby/execjs"

ruby_add_bdepend "test? (
	>=dev-ruby/rails-5.0.0
	dev-ruby/rake
	dev-ruby/rspec-rails
	dev-ruby/sprockets-rails
)"

all_ruby_prepare() {
	sed -i -e "/bundler/d" -e "/BUNDLE/d" spec/app/config/boot.rb || die
	sed -i -e "/Bundler/ s:^:#:" \
		-e '/config.sass/ s:^:#:' spec/app/config/application.rb || die
	rm -f spec/rails_spec.rb || die
}
