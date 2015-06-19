# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/riel/riel-1.2.0-r1.ebuild,v 1.4 2015/06/08 05:04:17 jer Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="Features.txt History.txt README.md README.rdoc"

inherit ruby-fakegem

DESCRIPTION="This library extends the core Ruby libraries"
HOMEPAGE="https://github.com/jpace/riel"

SRC_URI="https://github.com/jpace/riel/archive/v${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 hppa ~ppc ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rainbow-1.1.4 dev-ruby/logue"
