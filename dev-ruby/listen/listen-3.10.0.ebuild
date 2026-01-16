# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Listens to file modifications and notifies you about the changes"
HOMEPAGE="https://github.com/guard/listen"
SRC_URI="https://github.com/guard/listen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"

# Block on other packages trying to install a /usr/bin/listen
RDEPEND="!!media-radio/ax25-apps"

ruby_add_rdepend "dev-ruby/logger >=dev-ruby/rb-inotify-0.9.10"

ruby_add_bdepend "test? ( dev-ruby/thor )"

all_ruby_prepare() {
	rm -f Gemfile || die
	sed -i -e "/git/,+3d" -e "/rb-fsevent/d" ${PN}.gemspec || die
	sed -i -e "/rb-fsevent/d"  lib/listen/adapter/darwin.rb || die
	rm -rf spec/lib/listen/adapter/darwin_spec.rb || die
}

each_ruby_prepare() {
	mkdir spec/.fixtures || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	rm -rf spec/.fixtures || die
}
