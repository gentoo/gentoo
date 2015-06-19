# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/text-hyphen/text-hyphen-1.4.1.ebuild,v 1.13 2014/11/11 11:04:52 mrueg Exp $

EAPI=4
USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc History.rdoc"

inherit ruby-fakegem eutils

DESCRIPTION="Hyphenates various words according to the rules of the language the word is written in"
HOMEPAGE="http://rubyforge.org/projects/text-format"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	doc? (
		>=dev-ruby/hoe-2.8.0
	)
	test? (
		>=dev-ruby/hoe-2.8.0
	)"
