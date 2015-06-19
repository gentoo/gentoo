# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/parslet/parslet-1.6.2.ebuild,v 1.2 2015/03/24 16:27:50 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="HISTORY.txt README"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A small PEG based parser library"
HOMEPAGE="https://github.com/kschiess/parslet"
SRC_URI="https://github.com/kschiess/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend ">=dev-ruby/blankslate-2"

ruby_add_bdepend "test? ( dev-ruby/flexmock )"

all_ruby_prepare() {
	sed -i -e "/sdoc/d" Rakefile || die
	sed -i -e "/unless respond_to?(:failure_message)/,+3d" -e "s/failure_message do/failure_message_for_should do/" spec/parslet/pattern_spec.rb
	# Avoid spec calling out to ruby since we can't guarantee the
	# correct version of blankslate in this case.
	rm spec/acceptance/examples_spec.rb || die
}
