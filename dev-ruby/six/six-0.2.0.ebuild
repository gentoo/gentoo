# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/six/six-0.2.0.ebuild,v 1.5 2015/03/25 20:36:28 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.markdown"

inherit ruby-fakegem

DESCRIPTION="An ultra lite authorization library"
HOMEPAGE="https://github.com/randx/six"
SRC_URI="https://github.com/randx/six/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' spec/spec_helper.rb || die "sed failed"
}
