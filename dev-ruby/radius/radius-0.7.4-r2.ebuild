# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/radius/radius-0.7.4-r2.ebuild,v 1.1 2015/04/26 18:25:05 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG QUICKSTART.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Powerful tag-based template system"
HOMEPAGE="https://github.com/jlong/radius http://radius.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/kramdown )"

all_ruby_prepare() {
	sed -i -e "/simplecov/,/end/d" -e "/coveralls/d" test/test_helper.rb || die
}
