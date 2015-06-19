# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/simple-rss/simple-rss-1.3.1.ebuild,v 1.9 2015/04/26 17:04:27 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="A simple, flexible, extensible, and liberal RSS and Atom reader for Ruby"
HOMEPAGE="http://simple-rss.rubyforge.org/"
LICENSE="LGPL-2"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rspec )"

all_ruby_prepare() {
	# Avoid dependency on bundler
	sed -i -e '/bundler/d' Rakefile || die

	# https://github.com/cardmagic/simple-rss/pull/14
	sed -i -e 's/README/README.markdown/' Rakefile || die
}
