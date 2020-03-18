# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="HISTORY.txt README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Implements weak, soft, and strong references in Ruby"
HOMEPAGE="https://github.com/ruby-concurrency/ref"
SRC_URI="https://github.com/ruby-concurrency/ref/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/simplecov/,/^end/ s:^:#:' spec/spec_helper.rb || die
}
