# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Asynchronous response API for Sinatra and Thin"
HOMEPAGE="https://github.com/raggi/async_sinatra"
SRC_URI="https://github.com/raggi/async_sinatra/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? (
	>=dev-ruby/hoe-3.13
	>=dev-ruby/minitest-5.6:5
	>=dev-ruby/eventmachine-0.12.11
	dev-ruby/rake
	dev-ruby/rack-test
	)"

ruby_add_rdepend ">=dev-ruby/sinatra-1.3.2
	>=dev-ruby/rack-1.4.1:*"

each_ruby_test() {
	MT_NO_PLUGINS=true ${RUBY} -S rake test || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}/
	doins -r examples
}
