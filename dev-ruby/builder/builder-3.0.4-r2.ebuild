# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/builder/builder-3.0.4-r2.ebuild,v 1.1 2015/06/07 06:20:44 graaff Exp $

EAPI=5
# ruby22 - code incompatability
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="test_all"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc CHANGES"

inherit ruby-fakegem eutils

DESCRIPTION="A builder to facilitate programatic generation of XML markup"
HOMEPAGE="http://rubyforge.org/projects/builder/"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/rdoc )"

all_ruby_prepare() {
	sed -i \
		-e '/rdoc\.template .*jamis/d' \
		Rakefile || die

	# Backport for from 3.2 for ruby20 file encoding.
	sed -i -e '1i# encoding: us-ascii' test/test_xchar.rb || die
}
