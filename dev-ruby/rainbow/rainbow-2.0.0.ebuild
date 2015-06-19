# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rainbow/rainbow-2.0.0.ebuild,v 1.5 2015/06/08 05:02:32 jer Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.markdown"

inherit ruby-fakegem

DESCRIPTION="Colorize printed text on ANSI terminals"
HOMEPAGE="http://github.com/sickill/rainbow"

SRC_URI="https://github.com/sickill/rainbow/archive/v${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 hppa ~ppc ~sparc ~x86"
IUSE=""
