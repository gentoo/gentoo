# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="A dirt simple mechanism to tell if files have changed"
HOMEPAGE="https://github.com/benschwarz/watch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"
