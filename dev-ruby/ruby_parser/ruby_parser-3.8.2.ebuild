# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

inherit ruby-fakegem

DESCRIPTION="A ruby parser written in pure ruby"
HOMEPAGE="https://github.com/seattlerb/ruby_parser"

LICENSE="MIT"
SLOT="3"
KEYWORDS="alpha ~amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/sexp_processor-4.7.0:4
	!<dev-ruby/ruby_parser-2.3.1-r1"

ruby_add_bdepend "doc? ( >=dev-ruby/hoe-2.9.1 )"
ruby_add_bdepend "test? ( dev-ruby/racc >=dev-ruby/minitest-4.3 )"

DEPEND+=" test? ( dev-util/unifdef )"

all_ruby_prepare() {
	# Remove reference to perforce method that is not in a released
	# version of hoe-seattlerb.
	#sed -i -e '/perforce/d' Rakefile || die
	sed -i -e '/license/d' Rakefile || die
	sed -i -e '/Hoe.plugin :isolate/ s:^:#:' Rakefile || die
}
