# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="Forwardable with hash, and instance variable extensions"
HOMEPAGE="https://rubygems.org/gems/forwardable-extended http://github.com/envygeeks/forwardable-extended"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
