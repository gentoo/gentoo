# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A simple, powerful, and very fast logging utility"
HOMEPAGE="https://github.com/bdurand/lumberjack"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
