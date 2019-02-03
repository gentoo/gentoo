# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="A library which provides base32 decoding and encoding"
HOMEPAGE="https://rubygems.org/gems/base32 https://github.com/stesla/base32"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/minitest
	dev-ruby/rake )"

all_ruby_prepare() {
	sed -i -e "1,10d" Rakefile || die
}
