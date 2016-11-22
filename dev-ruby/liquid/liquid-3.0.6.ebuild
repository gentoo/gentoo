# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

inherit ruby-fakegem

SRC_URI="https://github.com/Shopify/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Template engine for Ruby"
HOMEPAGE="http://www.liquidmarkup.org/"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest
	dev-ruby/spy )"
