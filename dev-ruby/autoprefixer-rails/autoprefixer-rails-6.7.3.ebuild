# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Add vendor prefixes to CSS rules using values from the Can I Use website"
HOMEPAGE="https://github.com/ai/autoprefixer-rails"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="6"
IUSE=""

ruby_add_rdepend "dev-ruby/execjs:*"

ruby_add_bdepend "dev-ruby/rails
	dev-ruby/rake
	dev-ruby/rspec-rails"

all_ruby_prepare() {
	sed -i -e "/bundler/d" -e "/BUNDLE/d" spec/app/config/boot.rb || die
	sed -i -e "/Bundler/,+3d" spec/app/config/application.rb || die
	rm spec/rails_spec.rb spec/compass_spec.rb || die
}
