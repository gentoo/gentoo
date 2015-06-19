# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/plist/plist-3.1.0-r1.ebuild,v 1.5 2015/01/18 03:04:45 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A library to manipulate Property List files, also known as plists"
HOMEPAGE="http://plist.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RUBY_PATCHES=( "${FILESDIR}"/${P}-nordoc.patch )

all_ruby_prepare() {
	sed -e '/gempackagetask/ s:^:#:' \
		-e '/GemPackageTask/,/end/ s:^:#:' \
		-i Rakefile || die
}
