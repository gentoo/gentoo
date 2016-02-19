# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md SPEC.md"

inherit multilib ruby-fakegem

DESCRIPTION="Secret User Agent of HTTP"
HOMEPAGE="https://github.com/lostisland/sawyer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/faraday
	dev-ruby/addressable"
