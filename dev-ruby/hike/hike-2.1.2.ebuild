# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Hike is a Ruby library for finding files in a set of paths"
HOMEPAGE="https://github.com/sstephenson/hike"
LICENSE="MIT"
SRC_URI="https://github.com/sstephenson/hike/archive/v${PV}.tar.gz -> ${P}.tgz"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="2"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"
