# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="A mid-level packet manipulation library"
HOMEPAGE="https://rubygems.org/gems/packetfu"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

ruby_add_rdepend "
	dev-ruby/network_interface:0
	>=dev-ruby/pcaprub-0.9.2
"

ruby_add_bdepend "test? ( >=dev-ruby/rspec-its-1.2.0:1 )"
