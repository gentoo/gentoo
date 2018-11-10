# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

inherit ruby-fakegem

DESCRIPTION="Library for encoding QR Codes"
HOMEPAGE="https://whomwah.github.com/rqrcode/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/chunky_png:0"

all_ruby_prepare() {
	sed -i -e '1igem "minitest"' test/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e "Dir['test/test_r*.rb'].each{|f| require f}"
}
