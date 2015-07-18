# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-beautify/ruby-beautify-0.93.2.ebuild,v 1.4 2015/07/18 11:23:01 jer Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.md RELEASE.md"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="a cli tool (and module) to beautify ruby code"
HOMEPAGE="https://github.com/erniebrodeur/ruby-beautify"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~hppa ~ppc64"
SLOT="0"
IUSE=""
