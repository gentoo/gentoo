# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="A pure Ruby library for generating podcasts from mp3 files"
HOMEPAGE="https://github.com/boncey/ruby-podcast"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"

ruby_add_rdepend "dev-ruby/ruby-mp3info"

each_ruby_test() {
	${RUBY} -Ilib test/ts_podcast.rb || die "Tests failed."
}
