# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="A mid-level packet manipulation library"
HOMEPAGE="https://rubygems.org/gems/packetfu"

LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"

ruby_add_rdepend " >=dev-ruby/pcaprub-0.9.2:*"

RUBY_PATCHES=( "${FILESDIR}"/${P}-ruby2x-encoding.patch )

all_ruby_prepare() {
	# Broken for version numbers with multiple digits...
	sed -i -e '/reports a version number/,/end/ s:^:#:' spec/packetfu_spec.rb || die
}
