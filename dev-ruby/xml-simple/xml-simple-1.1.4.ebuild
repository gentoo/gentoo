# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/xml-simple/xml-simple-1.1.4.ebuild,v 1.3 2014/10/29 18:50:50 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

# Gem only contains lib code, and github repository has no tags.
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Easy API to maintain XML. It is a Ruby port of Grant McLean's Perl module XML::Simple"
HOMEPAGE="https://github.com/maik/xml-simple"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
