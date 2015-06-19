# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/colored/colored-1.2.ebuild,v 1.6 2015/01/25 09:50:32 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Console coloring"
HOMEPAGE="https://github.com/defunkt/colored"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

each_ruby_prepare() {
	sed -i -e '/[Mm][Gg]/d' Rakefile || die
}
