# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ruby22 support waiting on dev-ruby/action{pack,view}.
USE_RUBY="ruby20 ruby21"

# Avoid the complexity of the "rake" recipe and run the tests manually.
#RUBY_FAKEGEM_RECIPE_TEST=none

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Font files for the Ruby on Rails RBPDF plugin"
HOMEPAGE="https://github.com/naitoh/rbpdf"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e "/bundler/d" Rakefile || die
}

RESTRICT="test"
