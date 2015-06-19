# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/source_map/source_map-3.0.1.ebuild,v 1.6 2015/03/25 20:39:53 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Provides an API for parsing, and an API for generating source maps in ruby"
HOMEPAGE="https://github.com/ConradIrwin/ruby-source_map"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE=""

ruby_add_rdepend "dev-ruby/json"
