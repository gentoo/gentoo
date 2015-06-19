# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby2ruby/ruby2ruby-2.0.6.ebuild,v 1.10 2014/04/05 12:14:59 mrueg Exp $

EAPI=5

USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

inherit ruby-fakegem

DESCRIPTION="Generates readable ruby from ParseTree"
HOMEPAGE="http://seattlerb.rubyforge.org/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "
	dev-ruby/sexp_processor:4
	dev-ruby/ruby_parser:3
	!<dev-ruby/ruby2ruby-1.3.1-r1"
ruby_add_bdepend "doc?  ( dev-ruby/hoe dev-ruby/hoe-seattlerb )"

all_ruby_prepare() {
	sed -i -e '/plugin :isolate/ s:^:#:' Rakefile || die
}
