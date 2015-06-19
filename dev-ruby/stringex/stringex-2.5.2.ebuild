# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/stringex/stringex-2.5.2.ebuild,v 1.3 2014/08/12 21:05:23 blueness Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_DOC_DIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Extensions for Ruby's String class"
HOMEPAGE="http://github.com/rsl/stringex"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test"

# we could rely on activerecord[sqlite3], but since we do not remove the
# sqlite3 adapter from activerecord when building -sqlite3, it's easier
# to just add another dependency, so the user doesn't have to change the
# USE flags at all.
ruby_add_bdepend "
	test? (
		dev-ruby/redcloth
		dev-ruby/test-unit:2
	)"

USE_RUBY="ruby19" ruby_add_bdepend "test? ( >=dev-ruby/activerecord-3 dev-ruby/sqlite3 )"

each_ruby_prepare() {
		case ${RUBY} in
				*ruby2[01])
						# Avoid tests depending on Rails until we have a version
						# keyworded.
						rm -rf test/unit/{acts_as_url,localization}* || die
						;;
		esac
}

each_ruby_test() {
	# rake seems to break this
	ruby-ng_testrb-2 -Ilib -Itest test/unit/*/*_test.rb test/performance/*_test.rb || die "tests failed"
}
