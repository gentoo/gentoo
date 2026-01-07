# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="rqrcode_core.gemspec"

inherit ruby-fakegem

DESCRIPTION="Library for encoding QR Codes"
HOMEPAGE="https://github.com/whomwah/rqrcode_core/"
SRC_URI="https://github.com/whomwah/rqrcode_core/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/test_helper.rb || die
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/**/*_test.rb"].each {|f| require f}' || die
}
