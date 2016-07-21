# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README ChangeLog"

inherit ruby-fakegem

DESCRIPTION="Ruby library for GNTP(Growl Notification Transport Protocol)"
HOMEPAGE="https://github.com/snaka/ruby_gntp"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/rr )"

all_ruby_prepare() {
	mv test spec || die
	sed -i -e "s/Spec::Runner/RSpec/" \
		-e "s#\.\./lib/##"\
		spec/ruby_gntp_spec.rb || die

}
