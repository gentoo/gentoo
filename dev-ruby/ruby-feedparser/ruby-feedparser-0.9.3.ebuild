# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-feedparser/ruby-feedparser-0.9.3.ebuild,v 1.2 2014/07/25 02:22:19 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="ChangeLog README"

inherit ruby-fakegem

GITHUB_USER="feed2imap"

DESCRIPTION="Ruby library to parse ATOM/RSS feeds"
HOMEPAGE="http://github.com/feed2imap/ruby-feedparser"
SRC_URI="http://github.com/${GITHUB_USER}/${PN}/archive/${P//-/_}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RUBY_S="${PN}-${P//-/_}"

ruby_add_rdepend "dev-ruby/magic"

each_ruby_configure() {
	${RUBY} setup.rb config || die
}

each_ruby_install() {
	${RUBY} setup.rb install --prefix="${D}" || die
}
