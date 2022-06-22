# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="A simple, flexible, extensible, and liberal RSS and Atom reader for Ruby"
HOMEPAGE="https://github.com/cardmagic/simple-rss"
LICENSE="LGPL-2"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

all_ruby_prepare() {
	# Avoid dependency on bundler
	sed -i -e '/bundler/d' \
		-e '/rubyforgepublisher/I s:^:#:' \
		Rakefile || die

	# Avoid tests that require unpackaged test data
	sed -i -e '/@\(media_rss\|rss20_utf8\)/ s:^:#:' \
		-e '/test_rss_utf8/aomit "missing data"' \
		test/base/base_test.rb || die
}
