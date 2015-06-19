# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/parslet/parslet-1.6.1.ebuild,v 1.2 2014/05/31 14:11:11 ercpe Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="HISTORY.txt README"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="A small PEG based parser library"
HOMEPAGE="https://github.com/kschiess/parslet"
SRC_URI="https://github.com/kschiess/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend "dev-ruby/blankslate:2"

all_ruby_prepare() {
	sed -i -e "/sdoc/d" Rakefile || die

	# Make sure correct version of blankslate is used without bundler
	sed -i -e '1igem "blankslate", "~> 2.0"' spec/spec_helper.rb || die

	# Avoid spec calling out to ruby since we can't guarantee the
	# correct version of blankslate in this case.
	rm spec/acceptance/examples_spec.rb || die
}
