# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/coderay/coderay-1.1.0-r1.ebuild,v 1.12 2014/12/19 13:23:23 ago Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 jruby"

# The test target also contains test:exe but that requires
# shoulda-context which we do not have packaged yet.
RUBY_FAKEGEM_TASK_TEST="test:functional test:units"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="Changes-pre-1.0.textile Changes.textile FOLDERS README_INDEX.rdoc README.markdown"

inherit ruby-fakegem

DESCRIPTION="A Ruby library for syntax highlighting"
HOMEPAGE="http://coderay.rubychan.de/"
SRC_URI="https://github.com/rubychan/coderay/tarball/v${PV} -> ${P}.tgz"

RUBY_S="rubychan-coderay-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# Redcloth is optional but automagically tested, so we add this
# dependency to ensure that we get at least a version that works: bug
# 330621. We use this convoluted way because redcloth isn't available
# yet for jruby.
USE_RUBY="${USE_RUBY/jruby/}" ruby_add_bdepend "test? ( >=dev-ruby/redcloth-4.2.2 )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
	sed -i -e '/git ls-files/ s:^:#:' coderay.gemspec || die
}
