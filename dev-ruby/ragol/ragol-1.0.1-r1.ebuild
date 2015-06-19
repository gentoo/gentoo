# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ragol/ragol-1.0.1-r1.ebuild,v 1.4 2015/06/08 05:05:02 jer Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="Features.txt History.txt NEWS README.md"

inherit ruby-fakegem

DESCRIPTION="Another implementation of an option processor"
HOMEPAGE="https://github.com/jpace/ragol"

SRC_URI="https://github.com/jpace/ragol/archive/v${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 hppa ~ppc ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/logue-1.0.0"
