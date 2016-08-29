# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

# Tests are against the Flickr API and require an API key.
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="-r README.rdoc examples"

inherit ruby-fakegem

DESCRIPTION="A library to access flickr api in a simple way"
HOMEPAGE="https://github.com/hanklords/flickraw"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
