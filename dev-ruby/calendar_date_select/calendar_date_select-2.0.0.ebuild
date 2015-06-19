# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/calendar_date_select/calendar_date_select-2.0.0.ebuild,v 1.3 2015/03/20 13:31:09 graaff Exp $

EAPI=4

USE_RUBY="ruby19 ruby20 ruby21"

# There are no unit tests, only integration tests against a full Rails
# 3.2 application. Skipping those for now due to difficulty in getting
# all dependencies right.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md History.txt"

RUBY_FAKEGEM_EXTRAINSTALL="app"

inherit ruby-fakegem

DESCRIPTION="A popular and flexible JavaScript DatePicker for RubyOnRails"
HOMEPAGE="http://code.google.com/p/calendardateselect/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rails-3.1"
