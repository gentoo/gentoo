# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/flickraw/flickraw-0.9.8.ebuild,v 1.3 2015/02/01 13:53:45 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

# Tests are against the Flickr API and require an API key.
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="-r README.rdoc examples"

inherit ruby-fakegem

DESCRIPTION="A library to access flickr api in a simple way"
HOMEPAGE="http://github.com/hanklords/flickraw"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
