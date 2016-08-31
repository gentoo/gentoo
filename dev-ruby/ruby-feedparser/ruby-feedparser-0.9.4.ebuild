# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog.md README"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

GITHUB_USER="feed2imap"

DESCRIPTION="Ruby library to parse ATOM/RSS feeds"
HOMEPAGE="https://github.com/feed2imap/ruby-feedparser"
SRC_URI="https://github.com/${GITHUB_USER}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend "dev-ruby/magic"

ruby_add_bdepend "dev-ruby/magic
	test? ( dev-ruby/mocha )"

all_ruby_prepare() {
	# Extract gemspec source from Rakefile
	sed -n -e '/Gem::Specification/,/end$/p' Rakefile > ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e 's/PKG_NAME/"'${PN}'"/' \
		-e 's/PKG_VERSION/"'${PV}'"/' \
		-e '/s.files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_prepare() {
	sed -i -e '/PKG_VERSION/ s:ruby:'${RUBY}':' Rakefile || die
}
