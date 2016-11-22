# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="SSH private and public key generator in pure Ruby"
HOMEPAGE="https://rubygems.org/gems/sshkey"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

#no tests
RESTRICT="test"
