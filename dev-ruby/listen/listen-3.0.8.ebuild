# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

SRC_URI="https://github.com/guard/listen/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Listens to file modifications and notifies you about the changes"
HOMEPAGE="https://github.com/guard/listen"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~arm ~ppc64 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

# Block on other packages trying to install a /usr/bin/listen
RDEPEND+="!!media-sound/listen !!media-radio/ax25 !!<dev-ruby/listen-2.8.6-r1:2"

ruby_add_rdepend ">=dev-ruby/rb-inotify-0.9.7"

ruby_add_bdepend "test? ( dev-ruby/thor )"

all_ruby_prepare() {
	rm -f Gemfile || die

	# Avoid dependency on rb-fsevent since we do not support Darwin
	sed -i -e "/git/,+3d" -e "/rb-fsevent/d" ${PN}.gemspec || die
	rm -rf spec/lib/listen/adapter/darwin_spec.rb || die
	# Try Linux first since we now we use Linux and since the Darwin
	# adapter now throws errors when rb-fsevent is not present.
	sed -i -e 's/Darwin, Linux/Linux, Darwin/' lib/listen/adapter.rb || die
}

each_ruby_prepare() {
	mkdir spec/.fixtures || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	rm -rf spec/.fixtures || die
}
