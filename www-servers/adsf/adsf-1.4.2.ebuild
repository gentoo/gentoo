# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="../NEWS.md ../README.md"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="A Dead Simple Fileserver is a static file server that can launch in a directory"
HOMEPAGE="https://github.com/ddfreyne/adsf/"
SRC_URI="https://github.com/ddfreyne/adsf/archive/${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${P}/adsf"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.0.0:*"

ruby_add_bdepend "test? ( dev-ruby/rack-test )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/SimpleCov.command_name/ s:^:#:' \
		-e '/websocket/ s:^:#:' test/helper.rb || die
	sed -i -e '/test_receives_update/,/^  end/ s:^:#:' test/test_server.rb || die
	sed -i -e '/rubocop/I s:^:#:' Rakefile || die
	rm -f test/test_version.rb || die
}
