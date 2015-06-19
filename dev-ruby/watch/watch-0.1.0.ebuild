# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/watch/watch-0.1.0.ebuild,v 1.1 2013/12/25 19:33:56 naota Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="A dirt simple mechanism to tell if files have changed"
HOMEPAGE="http://github.com/benschwarz/watch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"
