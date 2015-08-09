# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="ChangeLog.md README.md"

inherit ruby-fakegem

DESCRIPTION="Calculates the differences between two tree-like structures"
HOMEPAGE="https://github.com/postmodern/tdiff"
LICENSE="MIT"

KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
SLOT="0"
IUSE=""
