# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

SRC_URI="https://github.com/sass/listen/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Fork of guard/listen provides a stable API for users of the ruby Sass CLI"
HOMEPAGE="https://github.com/guard/listen"
RUBY_S="listen-${PV}"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~riscv ~x86"
IUSE="test"

PATCHES=( "${FILESDIR}/listen-3.1.5-ruby26.patch" )

ruby_add_rdepend ">=dev-ruby/rb-inotify-0.9.7"

ruby_add_bdepend "test? ( dev-ruby/thor )"

all_ruby_prepare() {
	rm -f Gemfile || die
	sed -i -e "/git/,+3d" -e "/rb-fsevent/d" ${PN}.gemspec || die
	sed -i -e "/rb-fsevent/d"  lib/sass-listen/adapter/darwin.rb || die
	rm -rf spec/lib/listen/adapter/darwin_spec.rb || die
}

each_ruby_prepare() {
	mkdir spec/.fixtures || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	rm -rf spec/.fixtures || die
}
